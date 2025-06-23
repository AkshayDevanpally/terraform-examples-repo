# ===================================================================================================
# Variables for EC2 Instance Deployment Module
# This file defines all required inputs to provision an EC2 instance in a custom VPC setup.
# ===================================================================================================

# ---------------------------------------------------------------------------------------------------
# SSH Public Key Path
# Specifies the local path to the SSH public key used for EC2 key pair creation.
# ---------------------------------------------------------------------------------------------------
variable "public_key_path" {
  description = "Public key path"
  default     = "./levelup_key.pub"
}

# ---------------------------------------------------------------------------------------------------
# VPC ID
# The ID of the VPC where the EC2 instance will be deployed.
# ---------------------------------------------------------------------------------------------------
variable "VPC_ID" {
  type    = string
  default = ""
}

# ---------------------------------------------------------------------------------------------------
# Environment Name
# Used to tag resources with the environment (e.g., dev, staging, prod).
# ---------------------------------------------------------------------------------------------------
variable "ENVIRONMENT" {
  type    = string
  default = ""
}

# ---------------------------------------------------------------------------------------------------
# AWS Region
# Region where the resources will be deployed.
# ---------------------------------------------------------------------------------------------------
variable "AWS_REGION" {
  default = "us-east-1"
}

# ---------------------------------------------------------------------------------------------------
# AMI Map
# Maps each AWS region to a specific AMI ID for consistent instance creation.
# ---------------------------------------------------------------------------------------------------
variable "AMIS" {
  type = map

  default = {
    us-east-1 = "ami-0e9bbd70d26d7cf4f"   # N. Virginia
    us-east-2 = "ami-05692172625678b4e"   # Ohio
    us-west-2 = "ami-02c8896b265d8c480"   # Oregon
    eu-west-1 = "ami-0cdd3aca00188622e"   # Ireland
  }
}

# ---------------------------------------------------------------------------------------------------
# EC2 Instance Type
# Defines the instance type to be launched (e.g., t2.micro for free-tier).
# ---------------------------------------------------------------------------------------------------
variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

# ---------------------------------------------------------------------------------------------------
# Public Subnets List
# A list of public subnet IDs where the EC2 instance can be launched.
# ---------------------------------------------------------------------------------------------------
variable "PUBLIC_SUBNETS" {
  type = list
}

