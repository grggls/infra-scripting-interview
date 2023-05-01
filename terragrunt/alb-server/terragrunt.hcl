
terraform {
  source = "git::https://github.com/cloudposse/terraform-aws-alb.git//.?ref=1.7.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "subnets" {
  config_path = "../subnets"
}

inputs = {
  name                              = "serverlb"
  vpc_id                            = dependency.vpc.outputs.vpc_id
  ip_address_type                   = "ipv4"
  security_group_ids                = [dependency.vpc.outputs.vpc_default_security_group_id]
  subnet_ids                        = dependency.subnets.outputs.private_subnet_ids
  internal                          = true
  http_enabled                      = true
  access_logs_enabled               = true
  https_enabled                     = false
  cross_zone_load_balancing_enabled = true
  http2_enabled                     = true
  deletion_protection_enabled       = false
}
