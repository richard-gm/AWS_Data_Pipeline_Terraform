resource "aws_mskconnect_connector" "s3_sink" {
  name = "${var.prefix}-s3-sink-connector"

  kafkaconnect_version = "2.7.1"

  capacity {
    autoscaling {
      mcu_count        = 1
      min_worker_count = 1
      max_worker_count = 2
    }
  }

  connector_configuration = {
    "connector.class"                = "io.confluent.connect.s3.S3SinkConnector"
    "tasks.max"                      = "1"
    "topics"                         = var.kafka_topic_name
    "s3.bucket.name"                 = var.s3_bucket_name
    "s3.region"                      = var.aws_region
    "flush.size"                     = "1000"
    "storage.class"                  = "io.confluent.connect.s3.storage.S3Storage"
    "format.class"                   = "io.confluent.connect.s3.format.json.JsonFormat"
    "partitioner.class"              = "io.confluent.connect.storage.partitioner.DefaultPartitioner"
    "schema.compatibility"           = "NONE"
    "behavior.on.null.values"        = "ignore"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = module.msk_cluster.kafka_bootstrap_brokers

      vpc {
        security_groups = [module.security_group.kafka_sg_id]
        subnets         = var.subnet_ids
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "PLAINTEXT"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.s3_sink_plugin.arn
      revision = aws_mskconnect_custom_plugin.s3_sink_plugin.latest_revision
    }
  }

  service_execution_role_arn = module.security_group.msk_connect_role_arn
}

resource "aws_mskconnect_custom_plugin" "s3_sink_plugin" {
  name         = "${var.prefix}-s3-sink-plugin"
  content_type = "JAR"

  location {
    s3 {
      bucket_arn = var.s3_bucket_arn
      file_key   = "kafka-connect-s3-1.0.0.jar"
    }
  }
}
