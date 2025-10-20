variable "name" { type = string }
variable "tags" {
	type    = map(string)
	default = {}
}
variable "task_family" { type = string }
variable "cpu" { type = string }
variable "memory" { type = string }
variable "execution_role_arn" { type = string }
variable "task_role_arn" { type = string }
variable "container_definitions" { type = string }
variable "service_name" { type = string }
variable "desired_count" { type = number }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "target_group_arn" { type = string }
variable "container_name" { type = string }
variable "container_port" { type = number }
