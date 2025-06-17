# ============================================================================================
# 🛠️ Terraform Configuration for EC2 Instance Deployment using a VPC Module
# This script sets up an AWS provider, calls a reusable VPC module, creates a key pair,
# and provisions an EC2 instance into the defined network.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# 🌎 AWS Provider Block
# Sets the region where all resources will be created.
# --------------------------------------------------------------------------------------------
provider "aws" {
  region = var.region  # Example: "us-east-1"
}

# --------------------------------------------------------------------------------------------
# 📦 VPC Module
# This imports the custom module located in ./module/network which should output subnet and SG.
# --------------------------------------------------------------------------------------------
module "myvpc" {
  source = "./module/network"  # Local module path
}

# --------------------------------------------------------------------------------------------
# 🔐 SSH Key Pair Resource
# This uploads a local public SSH key to AWS for EC2 access.
# --------------------------------------------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                   # Name of the key in AWS
  public_key = file(var.public_key_path)       # Path to the local public key file
}

# --------------------------------------------------------------------------------------------
# 🖥️ EC2 Instance Resource
# Launches an EC2 instance into the VPC public subnet created by the module.
# --------------------------------------------------------------------------------------------
resource "aws_instance" "levelup_instance" {
  ami                    = var.instance_ami                        # AMI ID (e.g., Amazon Linux)
  instance_type          = var.instance_type                       # EC2 type (e.g., t2.micro)
  subnet_id              = module.myvpc.public_subnet_id           # Public subnet from module output
  vpc_security_group_ids = module.myvpc.sg_22_id                   # Security Group allowing SSH
  key_name               = aws_key_pair.levelup_key.key_name       # Use the uploaded key pair

  tags = {
    Environment = var.environment_tag  # e.g., "Development"
  }
}

