resource "aws_msk_configuration" "kafka_config" {
  name              = "${var.prefix}-kafka-config"
  kafka_versions    = ["2.8.1"]
  server_properties = <<PROPERTIES
auto.create.topics.enable=true
delete.topic.enable=true
PROPERTIES
}
