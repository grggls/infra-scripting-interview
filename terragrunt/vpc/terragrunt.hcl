terraform {
  source = "git::git@github.com:cloudposse/terraform-aws-vpc.git//.?ref=2.0.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name                             = "VPC01"
  ipv4_primary_cidr_block          = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = false
}
