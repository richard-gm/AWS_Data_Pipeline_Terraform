resource "aws_kms_key" "kafka_kms" {
  description = "KMS key for Kafka encryption at rest"
  tags = {
    Name        = "${var.prefix}-kafka-kms"
    Environment = var.environment
  }
}
