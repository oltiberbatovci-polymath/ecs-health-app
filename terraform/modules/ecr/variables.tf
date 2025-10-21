variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "tags" {
  description = "tags to apply to the ECR repository"
    type        = map(string)
    default     = {}
}