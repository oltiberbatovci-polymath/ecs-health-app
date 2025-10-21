variable "s3_bucket_domain_name" {
	description = "Domain name of the S3 bucket for CloudFront origin. Must not be empty."
	type        = string
}
variable "comment" { type = string }
variable "default_root_object" { type = string }
variable "price_class" { type = string }
variable "tags" {
	type    = map(string)
	default = {}
}
