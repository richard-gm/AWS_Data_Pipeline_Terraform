output "kafka_broker_ips" {
  description = "Private IPs of Kafka broker instances"
  value       = aws_instance.kafka_broker[*].private_ip
}

output "zookeeper_ips" {
  description = "Private IPs of ZooKeeper instances"
  value       = aws_instance.zookeeper[*].private_ip
}

output "kafka_lb_dns" {
  description = "DNS name of the Kafka load balancer"
  value       = aws_lb.kafka_lb.dns_name
}
