
terraform {
  source = "git::https://github.com/cloudposse/terraform-aws-ecr.git//.?ref=0.35.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name                   = "app"
  principals_full_access = ["arn:aws:iam::622140367382:user/Administrator"]
  image_tag_mutability   = "MUTABLE"
}
