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
  name                              = "alb"
  vpc_id                            = dependency.vpc.outputs.vpc_id
  ip_address_type                   = "ipv4"
  security_group_ids                = [dependency.vpc.outputs.vpc_default_security_group_id]
  subnet_ids                        = dependency.subnets.outputs.public_subnet_ids
  internal                          = false
  http_enabled                      = true
  https_enabled                     = false
  http_ingress_cidr_blocks          = ["0.0.0.0/0"]
  cross_zone_load_balancing_enabled = true
  http2_enabled                     = true
  access_logs_enabled               = true
  deletion_protection_enabled       = false
}
