resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "${var.prefix}-kafka-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = var.kafka_broker_count

  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    client_subnets  = var.subnet_ids
    security_groups = [aws_security_group.kafka_sg.id]

    storage_info {
      ebs_storage_info {
        volume_size = var.kafka_volume_size
      }
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kafka_kms.arn
  }

  configuration_info {
    arn      = aws_msk_configuration.kafka_config.arn
    revision = 1
  }

  tags = {
    Name        = "${var.prefix}-kafka-cluster"
    Environment = var.environment
  }
}

resource "aws_msk_configuration" "kafka_config" {
  name              = "${var.prefix}-kafka-config"
  kafka_versions    = ["2.8.1"]
  server_properties = <<PROPERTIES
auto.create.topics.enable=true
delete.topic.enable=true
PROPERTIES
}

resource "aws_kms_key" "kafka_kms" {
  description = "KMS key for Kafka encryption at rest"
  tags = {
    Name        = "${var.prefix}-kafka-kms"
    Environment = var.environment
  }
}

resource "aws_security_group" "kafka_sg" {
  name_prefix = "${var.prefix}-kafka-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.prefix}-kafka-sg"
    Environment = var.environment
  }
}
