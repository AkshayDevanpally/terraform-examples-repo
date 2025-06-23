# ===============================================================================================
# Terraform Configuration for Development Environment
# This script provisions a custom VPC and EC2 instances by invoking reusable modules.
# ===============================================================================================

# -----------------------------------------------------------------------------------------------
# VPC Module
# This module creates a Virtual Private Cloud with public subnets in the specified region.
# -----------------------------------------------------------------------------------------------
module "dev-vpc" {
  source      = "../modules/vpc"         # Path to the VPC module
  ENVIRONMENT = var.Env                 # Pass environment name (e.g., dev, qa, prod)
  AWS_REGION  = var.AWS_REGION          # Pass the AWS region
}

# -----------------------------------------------------------------------------------------------
# EC2 Instances Module
# Launches EC2 instances within the VPC created above, using the public subnets.
# -----------------------------------------------------------------------------------------------
module "dev-instances" {
  source          = "../modules/instances"          # Path to the instances module
  ENVIRONMENT     = var.Env                         # Environment tag (e.g., dev)
  AWS_REGION      = var.AWS_REGION                  # AWS region
  VPC_ID          = module.dev-vpc.my_vpc_id        # VPC ID output from VPC module
  PUBLIC_SUBNETS  = module.dev-vpc.public_subnets   # Public subnet IDs output from VPC module
}

# -----------------------------------------------------------------------------------------------
# AWS Provider Block
# Configures the AWS provider to use the selected region.
# -----------------------------------------------------------------------------------------------
provider "aws" {
  region = var.AWS_REGION
}

