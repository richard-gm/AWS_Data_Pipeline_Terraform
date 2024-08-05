provider "aws" {
  region = var.aws_region
}

module "kafka" {
  source      = "../../modules/kafka"
  environment = var.environment
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids
  prefix      = "${var.prefix}-${var.account_id}"
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
