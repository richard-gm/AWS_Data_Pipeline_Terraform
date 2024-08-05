variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-12345678"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "dev"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "s3-resource-dev"
}
