# Incode SRE Challenge 2.0

# Results

[The webapp](http://alb-1580287575.us-west-2.elb.amazonaws.com/)

<The diagram goes here>

# Objective

- [/]  Create an AWS account and use the free tier to provision the required elements.
- [ ]  Generate temporal IAM read-only users for us (Sean and Carlos) so we can check the implementation. You can send us the information to our Incode emails
- [/]  Generate a VPC (VPC01) with public and private subnets, and the required subnets elements (Route tables, Internet gateways, NAT or instance gateways, etc)
- [/]  Provision an application using ECS with EC2 and Fargate with the following elements:
    - [/]  public component
    - [/]  private component
    - [/]  database component
- [/]  all the required elements (security groups, roles, log groups, etc). The components must be interconnected, so for example the public layer must connect to the application layer and the application layer must connect to the database layer.
- [/]  A load balancer with target and auto-scalation groups must be utilized for each layer.
- [/]  For the database layer, please use an AWS managed service.
- [/]  Expose the application to Internet using a load balancer of the type you consider the best for this kind of implementation.
- [/]  No need to assign a domain name or TLS certificates, but explanation of what is required to do it will be necessary.
- [/]  Select and add five CloudWatch alarms related to the implementation.
- [ ]  We will require explanation about the reasons of the selected alarms.
- [ ]  A diagram with the implementation is required.
- [/]  The candidate can implement the requested elements manually using the AWS console, but extra points are earned if you use some infrastructure as code technology.

# Pre-Conditions

- I created an Administrator account in IAM via the console, by hand. That ARN is hard-coded in a couple of places. This is not best-practice but it got this project running quickly.
- I wasn't quite sure how to satisfy the requirement "ECS with EC2 and Fargate". My ECS cluster uses the FARGATE provider, so there's no EC2 instances to manage here.

# Requirements

 - Terraform v1.4.4
 - Terragrunt v0.45.2

# Howto

```
> git clone git@github.com:grggls/infra-scripting-interview.git
> cd ./infra-scripting-interview/terragrunt
> terragrunt run-all apply
```

In a fresh AWS account this will run partially and generate some errors. The initial layer of dependencies - VPC, DynamoDB (for tfstate locking and for application data) and ECR should build without error. Once the ECR repo is created, pause with Terragrunt and return to the root of the directory and do some docker work:

```
> cd ../docker && pwd
> ./infra-scripting-interview/docker
> ./build-and-push.sh
```

The `app` ECR repo is now populated with a new container image with the `latest` tag. That's what we need to deploy a task to the ECS cluster. A brief note on security - this is the only place that we tolerate "latest" or unbounded version constraints in this project. Terraform modules, python libraries, and tooling version constraints should all be in place.

Return to the terragrunt directory and continue to `terragrunt run-all apply` repeatedly until the infrastructure converges.

You can then navigate to the DynamoDB section of the AWS console, go into the `dynamodb01` table, and add some items for your webapp to transmit to the world.

# Dependencies

I made heavy use of the [Cloudposse terraform modules](https://registry.terraform.io/namespaces/cloudposse). One in particular did 90% of the heavy lifting here - https://registry.terraform.io/modules/cloudposse/ecs-web-app/aws/1.8.1

This module created all the Cloudwatch alarms enabled in the webapp:

|Name | Conditions |
|-----|------------|
|app-3xx-count-high, HTTPCode_Target_3XX_Count > 25 for 1 datapoints within 5 minutes |
|app-4xx-count-high, HTTPCode_Target_4XX_Count > 25 for 1 datapoints within 5 minutes |
|app-5xx-count-high, HTTPCode_Target_5XX_Count > 25 for 1 datapoints within 5 minutes |
|app-cpu-utilization-high, CPUUtilization > 80 for 1 datapoints within 5 minutes |
|app-cpu-utilization-low, CPUUtilization < 20 for 1 datapoints within 5 minutes |
|app-elb-5xx-count-high, HTTPCode_ELB_5XX_Count > 25 for 1 datapoints within 5 minutes |
|app-memory-utilization-high, MemoryUtilization > 80 for 1 datapoints within 5 minutes |
|app-memory-utilization-low, MemoryUtilization < 20 for 1 datapoints within 5 minutes |
|app-target-response-high, TargetResponseTime > 0.5 for 1 datapoints within 5 minutes |

The 