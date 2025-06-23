# ============================================================================================
# 🚀 Terraform EC2 Cluster Deployment Using a Public Module
# This script provisions one or more EC2 instances depending on the environment, using the
# community-maintained terraform-aws-ec2-instance module.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# 🌍 AWS Provider Block
# Configures the AWS region where infrastructure will be deployed.
# --------------------------------------------------------------------------------------------
provider "aws" {
  region = var.AWS_REGION  # Example: "us-east-1"
}

# --------------------------------------------------------------------------------------------
# 📦 EC2 Cluster Module
# Uses the official Terraform AWS EC2 Instance module to manage EC2 instances.
# --------------------------------------------------------------------------------------------
module "ec2_cluster" {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"  # Pulls module from GitHub

  name           = "my-cluster"                 # Name prefix for instances
  ami            = "ami-0e9bbd70d26d7cf4f"      # Example Amazon Linux 2 AMI
  instance_type  = "t2.micro"                   # Free-tier eligible EC2 type
  subnet_id      = "subnet-0ae34bdc2f72d96c3"   # Subnet where EC2 instances will be launched

  # Conditional instance count based on environment type
  instance_count = var.environment == "Production" ? 2 : 1

  tags = {
    Terraform   = "true"
    Environment = var.environment              # e.g., "Production" or "Development"
  }
}

