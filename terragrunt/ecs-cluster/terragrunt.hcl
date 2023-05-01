terraform {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-cluster.git//.?ref=0.3.1"
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

dependency "ecr-client" {
  config_path = "../ecr-client"
}

dependency "ecr-server" {
  config_path = "../ecr-server"
}

inputs = {
  namespace                       = "interview"
  name                            = "gpd"
  container_insights_enabled      = true
  capacity_providers_fargate      = true
  capacity_providers_fargate_spot = true
}
