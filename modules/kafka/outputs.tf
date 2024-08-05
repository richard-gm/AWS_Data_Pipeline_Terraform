output "kafka_bootstrap_brokers" {
  description = "Plaintext connection host:port pairs"
  value       = aws_msk_cluster.kafka_cluster.bootstrap_brokers
}

output "kafka_zookeeper_connect_string" {
  description = "ZooKeeper connection string"
  value       = aws_msk_cluster.kafka_cluster.zookeeper_connect_string
}

output "kafka_cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = aws_msk_cluster.kafka_cluster.arn
}

output "kafka_config_arn" {
  description = "ARN of the MSK configuration"
  value       = aws_msk_configuration.kafka_config.arn
}

output "kafka_sg_id" {
  description = "ID of the Kafka security group"
  value       = aws_security_group.kafka_sg.id
}

output "kafka_kms_arn" {
  description = "ARN of the KMS key for Kafka encryption"
  value       = aws_kms_key.kafka_kms.arn
}

output "msk_connect_role_arn" {
  description = "ARN of the IAM role for MSK Connect"
  value       = aws_iam_role.msk_connect_role.arn
}
