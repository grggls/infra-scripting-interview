terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

dependency "webapp" {
  config_path = "../webapp"
}

inputs = {
  ecs_task_role_name = dependency.webapp.outputs.ecs_task_role_name
}