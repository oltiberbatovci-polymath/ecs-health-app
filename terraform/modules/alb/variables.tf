variable "name" { type = string }
variable "security_group_ids" { type = list(string) }
variable "subnet_ids" { type = list(string) }
variable "enable_deletion_protection" { type = bool }
variable "tags" {
	type    = map(string)
	default = {}
}
variable "target_group_name" { type = string }
variable "port" { type = number }
variable "protocol" { type = string }
variable "vpc_id" { type = string }
variable "health_check_path" { type = string }
variable "listener_port" { type = number }
variable "listener_protocol" { type = string }
