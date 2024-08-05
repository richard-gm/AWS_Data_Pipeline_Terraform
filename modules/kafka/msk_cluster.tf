resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "${var.prefix}-kafka-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = var.kafka_broker_count

  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    client_subnets  = var.subnet_ids
    security_groups = [module.security_group.kafka_sg_id]

    storage_info {
      ebs_storage_info {
        volume_size = var.kafka_volume_size
      }
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = module.kms.kafka_kms_arn
  }

  configuration_info {
    arn      = module.msk_configuration.kafka_config_arn
    revision = 1
  }

  tags = {
    Name        = "${var.prefix}-kafka-cluster"
    Environment = var.environment
  }
}
