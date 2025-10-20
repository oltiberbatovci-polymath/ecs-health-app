terraform {
  backend "s3" {
    bucket = "ecs-health-app"
    key    = "global/s3/terraform.tfstate"
    region = "eu-north-1"
  }
}
