variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "kafka_broker_count" {
  description = "Number of Kafka broker instances"
  type        = number
  default     = 2
}

variable "kafka_ami" {
  description = "AMI ID for Kafka instances"
  type        = string
}

variable "kafka_instance_type" {
  description = "Instance type for Kafka brokers"
  type        = string
  default     = "t3.medium"
}

variable "ssh_key_name" {
  description = "SSH key name for EC2 instances"
  type        = string
}
