terraform {
  source = "git::git@github.com:cloudposse/terraform-aws-dynamodb.git//.?ref=0.32.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name                         = "DYNAMODB01"
  hash_key                     = "HashKey"
  autoscale_write_target       = 5
  autoscale_read_target        = 5
  autoscale_min_read_capacity  = 5
  autoscale_max_read_capacity  = 20
  autoscale_min_write_capacity = 5
  autoscale_max_write_capacity = 20
  enable_autoscaler            = false
}
