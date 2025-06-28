#############################################################
# Purpose and Overview:
# This is the main Terraform entry point that:
# - Calls a custom VPC module to provision a VPC, private and public subnets
# - Calls a webserver module to deploy Auto Scaling EC2 instances behind an Application Load Balancer (ALB)
# - Passes required VPC outputs to the webserver module for use in launching resources
# - Defines AWS as the provider with region selection
# - Outputs the ALB DNS name for public access
#
# This setup promotes modular infrastructure code that is reusable and environment-specific.
#############################################################

# Call the VPC module located at ./modules/vpc
# This module will create:
# - a custom VPC
# - public and private subnets
# - routing
# - internet gateway and NAT gateway if needed
module "levelup-vpc" {
  source      = "./modules/vpc"

  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

# Call the webserver module located at ./webserver
# This module will:
# - deploy EC2 instances in an Auto Scaling Group
# - attach a security group and a launch template
# - configure a Load Balancer (ALB)
# - use both public and private subnets from the VPC module
module "levelup-webserver" {
  source      = "./webserver"

  ENVIRONMENT           = var.ENVIRONMENT
  AWS_REGION            = var.AWS_REGION
  vpc_private_subnet1   = module.levelup-vpc.private_subnet1_id
  vpc_private_subnet2   = module.levelup-vpc.private_subnet2_id
  vpc_id                = module.levelup-vpc.my_vpc_id
  vpc_public_subnet1    = module.levelup-vpc.public_subnet1_id
  vpc_public_subnet2    = module.levelup-vpc.public_subnet2_id
}

# Set up the AWS provider with the desired region
provider "aws" {
  region = var.AWS_REGION
}

# Output the Load Balancer DNS name
# This allows you to view the public-facing address after `terraform apply`
output "load_balancer_output" {
  description = "Load Balancer"
  value       = module.levelup-webserver.load_balancer_output
}

