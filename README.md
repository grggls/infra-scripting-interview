# Incode SRE Challenge 2.0

# Objective

- [/]  Create an AWS account and use the free tier to provision the required elements.
- [ ]  Generate temporal IAM read-only users for us (Sean and Carlos) so we can check the implementation. You can send us the information to our Incode emails
- [/]  Generate a VPC (VPC01) with public and private subnets, and the required subnets elements (Route tables, Internet gateways, NAT or instance gateways, etc)
- [ ]  Provision an application using ECS with EC2 and Fargate with the following elements:
    - [ ]  public component
    - [ ]  private component
    - [/]  database component
- [/]  all the required elements (security groups, roles, log groups, etc). The components must be interconnected, so for example the public layer must connect to the application layer and the application layer must connect to the database layer.
- [/]  A load balancer with target and auto-scalation groups must be utilized for each layer.
- [/]  For the database layer, please use an AWS managed service.
- [/]  Expose the application to Internet using a load balancer of the type you consider the best for this kind of implementation.
- [ ]  No need to assign a domain name or TLS certificates, but explanation of what is required to do it will be necessary.
- [ ]  Select and add five CloudWatch alarms related to the implementation.
- [ ]  We will require explanation about the reasons of the selected alarms.
- [ ]  A diagram with the implementation is required.
- [ ]  The candidate can implement the requested elements manually using the AWS console, but extra points are earned if you use some infrastructure as code technology.

# Pre-Conditions

- I created an Administrator account in IAM via the console, by hand. That ARN is hard-coded in a couple of places. This is not best-practice but it got this project running quickly.

# Requirements

 - Terraform v1.4.4
 - Terragrunt v0.45.2

# Howto

```
> git clone git@github.com:grggls/infra-scripting-interview.git
> cd ./infra-scripting-interview/terragrunt
> terragrunt run-all init
> terragrunt run-all apply
```

In a fresh AWS account this will run partially and generate some errors. The initial layer of dependencies - VPC and ECRs should build without error. Once the ECR repos are created, pause with Terragrunt and return to the root of the directory and do some docker work:

```
> cd ../docker && pwd
> ./infra-scripting-interview/docker
> ./build-and-push.sh
```

Two ECR repos will have been populated by this script: `client` and `server`

Return to the terragrunt directory and continue to `terragrunt run-all apply` until the infrastructure converges. Specifically, the `./terragrunt/{client,server}` directories will be much more apt to run to completion now that there are container images in ECR to deploy with.
