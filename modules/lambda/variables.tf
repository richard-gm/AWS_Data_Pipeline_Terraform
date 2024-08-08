variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers"
  type        = string
}

variable "kafka_topic_name" {
  description = "Name of the Kafka topic"
  type        = string
}

variable "stock_market_api_endpoint" {
  description = "Endpoint of the StockMarket API"
  type        = string
}

variable "msk_cluster_arn" {
  description = "ARN of the MSK cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Lambda VPC configuration"
  type        = list(string)
}

variable "lambda_security_group_id" {
  description = "ID of the security group for Lambda VPC configuration"
  type        = string
}