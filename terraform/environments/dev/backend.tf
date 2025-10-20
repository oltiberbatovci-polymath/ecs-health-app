terraform {
  backend "s3" {
    bucket = "ecs-health-app"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
