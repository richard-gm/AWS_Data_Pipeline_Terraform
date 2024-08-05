variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}
