resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "${var.prefix}_kafka_cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = var.subnet_ids
    security_groups = [aws_security_group.kafka_sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kafka_kms.arn
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "kafka_sg" {
  name_prefix = "${var.prefix}_kafka_sg"
  vpc_id      = var.vpc_id

  # Add necessary ingress and egress rules
}

resource "aws_kms_key" "kafka_kms" {
  description = "KMS key for Kafka encryption at rest"
}

resource "aws_lb" "kafka_lb" {
  name               = "${var.prefix}_kafka_lb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.kafka_lb_sg.id]

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "kafka_tg" {
  name     = "${var.prefix}_kafka_tg"
  port     = 9092
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "kafka_listener" {
  load_balancer_arn = aws_lb.kafka_lb.arn
  port              = 9092
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kafka_tg.arn
  }
}
