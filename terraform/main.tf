// Root Terraform configuration
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.project_name
}

module "vpc" {
  source         = "./modules/vpc"
  name           = var.project_name
  cidr_block     = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets= var.private_subnets
  azs            = var.azs
  tags           = var.tags
}

# Example security group for ALB and ECS (replace with your own or module output)
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}


module "alb" {
  source                  = "./modules/alb"
  name                    = "${var.project_name}-alb"
  security_group_ids      = [aws_security_group.alb_sg.id]
  subnet_ids              = module.vpc.public_subnet_ids
  enable_deletion_protection = false
  tags                    = var.tags
  target_group_name       = "${var.project_name}-tg"
  port                    = 80
  protocol                = "HTTP"
  vpc_id                  = module.vpc.vpc_id
  health_check_path       = "/health"
  listener_port           = 80
  listener_protocol       = "HTTP"
}

module "ecs" {
  source                = "./modules/ecs"
  name                  = var.project_name
  tags                  = var.tags
  task_family           = "${var.project_name}-task"
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = "" # To be filled with IAM module output
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "472656844660.dkr.ecr.eu-north-1.amazonaws.com/ecs-health-app:latest"
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
      environment = [{ name = "NODE_ENV", value = "production" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}-ecs-logs"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  service_name          = "${var.project_name}-service"
  desired_count         = 1
  subnet_ids            = module.vpc.private_subnet_ids
  security_group_ids    = [aws_security_group.alb_sg.id]
  target_group_arn      = module.alb.target_group_arn
  container_name        = "app"
  container_port        = 80
}

module "cloudwatch" {
  source              = "./modules/cloudwatch"
  ecs_log_group_name  = "${var.project_name}-ecs-logs"
  retention_in_days   = 7
  tags                = var.tags
  dashboard_name      = "${var.project_name}-dashboard"
  dashboard_body      = <<EOF
{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 3,
      "properties": {
        "markdown": "# HealthTech Dashboard"
      }
    }
  ]
}
EOF
  cpu_alarm_name      = "${var.project_name}-cpu-high"
  cpu_threshold       = 80
  alarm_actions       = [] # To be filled with SNS topic ARN
  ecs_cluster_name    = module.ecs.cluster_id
  ecs_service_name    = module.ecs.service_name
}

module "cloudfront" {
  source                = "./modules/cloudfront"
  s3_bucket_domain_name = "${module.s3.bucket_name}.s3.amazonaws.com"
  comment               = "Patient dashboard distribution"
  default_root_object   = "index.html"
  price_class           = "PriceClass_100"
  tags                  = var.tags
}

module "iam" {
  source               = "./modules/iam"
  execution_role_name  = "${var.project_name}-ecs-exec"
  tags                 = var.tags
}

module "xray" {
  source            = "./modules/xray"
  filter_expression = "service(\"app\")"
  group_name        = "${var.project_name}-xray"
  tags              = var.tags
}
