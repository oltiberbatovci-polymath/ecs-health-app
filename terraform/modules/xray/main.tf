resource "aws_xray_group" "main" {
  filter_expression = var.filter_expression
  group_name        = var.group_name
  insights_configuration {
    insights_enabled = true
    notifications_enabled = true
  }
  tags = var.tags
}
