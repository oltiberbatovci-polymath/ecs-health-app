module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.project_name
}

module "vpc" {
  source         = "../../modules/vpc"
  name           = var.project_name
  cidr_block     = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets= var.private_subnets
  azs            = var.azs
  tags           = var.tags
}

module "alb" {
  source                  = "../../modules/alb"
  name                    = "${var.project_name}-alb"
  security_group_ids      = [] # To be filled with SG module output
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
  source                = "../../modules/ecs"
  name                  = var.project_name
  tags                  = var.tags
  task_family           = "${var.project_name}-task"
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = "" # To be filled with IAM module output
  task_role_arn         = "" # To be filled with IAM module output
  container_definitions = "[]" # To be filled with actual container definition
  service_name          = "${var.project_name}-service"
  desired_count         = 1
  subnet_ids            = module.vpc.private_subnet_ids
  security_group_ids    = [] # To be filled with SG module output
  target_group_arn      = module.alb.target_group_arn
  container_name        = "app"
  container_port        = 80
}

module "cloudwatch" {
  source              = "../../modules/cloudwatch"
  ecs_log_group_name  = "${var.project_name}-ecs-logs"
  retention_in_days   = 7
  tags                = var.tags
  dashboard_name      = "${var.project_name}-dashboard"
  dashboard_body      = "{}" # To be filled with actual dashboard JSON
  cpu_alarm_name      = "${var.project_name}-cpu-high"
  cpu_threshold       = 80
  alarm_actions       = [] # To be filled with SNS topic ARN
  ecs_cluster_name    = module.ecs.cluster_id
  ecs_service_name    = module.ecs.service_name
}

module "cloudfront" {
  source                = "../../modules/cloudfront"
  s3_bucket_domain_name = "" # To be filled with S3 bucket domain
  comment               = "Patient dashboard distribution"
  default_root_object   = "index.html"
  price_class           = "PriceClass_100"
  tags                  = var.tags
}

module "iam" {
  source               = "../../modules/iam"
  execution_role_name  = "${var.project_name}-ecs-exec"
  tags                 = var.tags
}

module "xray" {
  source            = "../../modules/xray"
  filter_expression = "service(\"app\")"
  group_name        = "${var.project_name}-xray"
  tags              = var.tags
}
