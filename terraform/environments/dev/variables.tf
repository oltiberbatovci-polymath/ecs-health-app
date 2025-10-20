variable "project_name" {
	description = "Project name for tagging and resource naming"
	type        = string
	default     = "ecs-health-app"
}

variable "vpc_cidr" {
	description = "VPC CIDR block"
	type        = string
	default     = "10.0.0.0/16"
}

variable "public_subnets" {
	description = "List of public subnet CIDRs"
	type        = list(string)
	default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
	description = "List of private subnet CIDRs"
	type        = list(string)
	default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
	description = "Availability zones"
	type        = list(string)
	default     = ["eu-north-1a", "eu-north-1b"]
}

variable "tags" {
	description = "Global tags for resources"
	type        = map(string)
	default     = {}
}
