terraform {
  source = "../modules/terraform-aws-ecs-web-app"
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

dependency "sns" {
  config_path = "../sns"
}

dependency "ecs" {
  config_path = "../ecs"
}

dependency "alb" {
  config_path = "../alb"
}

inputs = {
  name        = "app"
  launch_type = "FARGATE"
  vpc_id      = dependency.vpc.outputs.vpc_id

  container_image  = "622140367382.dkr.ecr.us-west-2.amazonaws.com/app"
  desired_count    = "2"
  container_cpu    = 256
  container_memory = 512
  container_port   = 3000
  port_mappings = [
    {
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }
  ]

  container_environment = [
    {
      name  = "LAUNCH_TYPE"
      value = "FARGATE"
    },
    {
      name  = "VPC_ID"
      value = dependency.vpc.outputs.vpc_id
    },
    {
      name  = "PORT"
      value = "3000"
    }
  ]

  codepipeline_enabled = false
  ecr_enabled          = false
  webhook_enabled      = false
  badge_enabled        = false
  ecs_alarms_enabled   = true
  autoscaling_enabled  = true

  ecs_cluster_arn        = dependency.ecs.outputs.arn
  ecs_cluster_name       = dependency.ecs.outputs.name
  ecs_private_subnet_ids = dependency.subnets.outputs.private_subnet_ids

  capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
      base              = 1
      weight            = 100
    }
  ]

  autoscaling_dimension             = "cpu"
  autoscaling_min_capacity          = 1
  autoscaling_max_capacity          = 2
  autoscaling_scale_up_adjustment   = 1
  autoscaling_scale_up_cooldown     = 60
  autoscaling_scale_down_adjustment = -1
  autoscaling_scale_down_cooldown   = 300

  log_driver      = "awslogs"
  aws_logs_region = "us-west-2"

  alb_security_group                              = dependency.alb.outputs.security_group_id
  alb_ingress_unauthenticated_listener_arns       = dependency.alb.outputs.listener_arns
  alb_arn_suffix                                  = dependency.alb.outputs.alb_arn_suffix
  alb_ingress_unauthenticated_listener_arns_count = 1
  alb_ingress_healthcheck_path                    = "/healthz"
  alb_ingress_unauthenticated_paths               = ["/*"]
  alb_ingress_listener_unauthenticated_priority   = 100


  #alb_target_group_alarms_enabled                 = true
  #alb_target_group_alarms_3xx_threshold           = 25
  #alb_target_group_alarms_4xx_threshold           = 25
  #alb_target_group_alarms_5xx_threshold           = 25
  #alb_target_group_alarms_response_time_threshold = 0.5
  #alb_target_group_alarms_period                  = 300
  #alb_target_group_alarms_evaluation_periods      = 1
  #alb_ingress_healthcheck_path                    = "/"
}
