# --------------------------------------------------------------------------------------------------
# Variables for EC2 Instance Module
# These variables provide configuration flexibility for provisioning EC2 instances dynamically.
# --------------------------------------------------------------------------------------------------

# Path to your local public SSH key that will be used to create an AWS key pair
variable "public_key_path" {
  description = "Public key path"
  default     = "./levelup_key.pub"         # Update this path if your key is elsewhere
}

# Environment name used for tagging and grouping resources (e.g., development, staging, prod)
variable "ENVIRONMENT" {
  type        = string
  default     = "development"                    # Default environment is development
}

# AMI ID for the EC2 instance
# This should be overridden with a region-specific AMI (e.g., Ubuntu or Amazon Linux)
variable "AMI_ID" {
  type        = string
  default     = ""                               # Must be provided unless hardcoded elsewhere
}

# AWS Region where resources will be created
# Determines the region-specific behavior such as available AZs, AMIs, and pricing
variable "AWS_REGION" {
  default     = "us-east-1"                      # Ohio region as default
}

# Type of EC2 instance to launch (e.g., t2.micro, t3.medium)
# Useful for controlling cost and performance
variable "INSTANCE_TYPE" {
  default     = "t2.micro"                       # Free-tier eligible instance type
}

