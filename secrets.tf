resource "aws_secretsmanager_secret" "kafka_credentials" {
  name = "kafka-credentials-${var.environment}"
}

resource "aws_secretsmanager_secret_version" "kafka_credentials" {
  secret_id     = aws_secretsmanager_secret.kafka_credentials.id
  secret_string = jsonencode({
    username = var.kafka_username
    password = var.kafka_password
  })
}
