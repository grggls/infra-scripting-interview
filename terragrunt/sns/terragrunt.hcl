terraform {
  source = "git::git@github.com:cloudposse/terraform-aws-sns-topic.git//.?ref=0.20.3"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name               = "webapp-sns-topic"
  encryption_enabled = true
  kms_master_key_id  = "alias/aws/sns"
}
