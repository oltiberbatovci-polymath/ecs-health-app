// Root outputs
output "alb_dns_name" {
	value = module.alb.lb_dns_name
}

output "cloudfront_domain" {
	value = module.cloudfront.domain_name
}

output "s3_bucket_name" {
	value = module.s3.bucket_name
}

output "ecs_service_name" {
	value = module.ecs.service_name
}

output "cloudwatch_dashboard_name" {
	value = module.cloudwatch.dashboard_name
}

output "xray_group_arn" {
	value = module.xray.xray_group_arn
}
