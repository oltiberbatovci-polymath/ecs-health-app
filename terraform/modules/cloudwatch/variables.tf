variable "ecs_log_group_name" { type = string }
variable "retention_in_days" { type = number }
variable "tags" {
	type    = map(string)
	default = {}
}
variable "dashboard_name" { type = string }
variable "dashboard_body" { type = string }
variable "cpu_alarm_name" { type = string }
variable "cpu_threshold" { type = number }
variable "alarm_actions" { type = list(string) }
variable "ecs_cluster_name" { type = string }
variable "ecs_service_name" { type = string }
