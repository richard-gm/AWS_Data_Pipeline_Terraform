variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-87654321"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
  default     = ["subnet-11111111", "subnet-22222222"]
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "prod"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "s3-resource-prod"
}
