# Main entry point for the Kafka module
module "msk_cluster" {
  source = "./msk_cluster"
}

module "msk_configuration" {
  source = "./msk_configuration"
}

module "msk_connect" {
  source = "./msk_connect"
}

module "security_group" {
  source = "./security_group"
}

module "kms" {
  source = "./kms"
}
