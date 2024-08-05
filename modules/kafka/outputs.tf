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
