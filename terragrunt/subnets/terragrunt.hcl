terraform {
  source = "git::git@github.com:cloudposse/terraform-aws-dynamic-subnets.git//.?ref=2.1.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  availability_zones       = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_id                   = dependency.vpc.outputs.vpc_id
  igw_id                   = [dependency.vpc.outputs.igw_id]
  ipv4_cidr_block          = [dependency.vpc.outputs.vpc_cidr_block]
  nat_gateway_enabled      = true
  nat_instance_enabled     = false
  aws_route_create_timeout = "5m"
  aws_route_delete_timeout = "10m"
}