provider "aws" {
  region = var.aws_region
}

module "kafka" {
  source              = "../../modules/kafka"
  environment         = var.environment
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  prefix              = "${var.prefix}-${var.account_id}"
  kafka_broker_count  = 3
  kafka_instance_type = "kafka.m5.large"
  kafka_volume_size   = 1000
  kafka_topic_name    = "${var.prefix}-stock-market-data"
  s3_bucket_name      = module.s3.bucket_name
  s3_bucket_arn       = module.s3.bucket_arn
  aws_region          = var.aws_region
}

module "lambda" {
  source                     = "../../modules/lambda"
  prefix                     = "${var.prefix}-${var.account_id}"
  environment                = var.environment
  kafka_bootstrap_servers    = module.kafka.kafka_bootstrap_brokers
  kafka_topic_name           = "${var.prefix}-stock-market-data"
  stock_market_api_endpoint  = var.stock_market_api_endpoint
  msk_cluster_arn            = module.kafka.kafka_cluster_arn
  subnet_ids               = var.subnet_ids
  lambda_security_group_id = aws_security_group.lambda_sg.id
}

resource "aws_security_group" "lambda_sg" {
  name_prefix = "${var.prefix}-lambda-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.prefix}-lambda-sg"
    Environment = var.environment
  }
}

module "s3" {
  source      = "../../modules/s3"
  environment = var.environment
  prefix      = "${var.prefix}-${var.account_id}"
}

module "glue" {
  source         = "../../modules/glue"
  environment    = var.environment
  s3_bucket_name = var.s3_bucket_name
  prefix         = "${var.prefix}-${var.account_id}"
}
