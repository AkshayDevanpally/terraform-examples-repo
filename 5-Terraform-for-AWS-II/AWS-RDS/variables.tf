# ============================================================================================
# Purpose:
# This file defines all the required variables for deploying AWS resources using Terraform.
# It includes access credentials, region, AMI mappings, security groups, and SSH key paths.

# Key Concepts:
# - Variables allow customization and parameterization of Terraform configurations
# - Access keys are used for AWS authentication
# - Maps and lists are used for storing region-specific AMIs and multiple security groups
# - Defaults are set to avoid manual input during every run
# ============================================================================================

# AWS Access Key: Used to authenticate with AWS
variable "AWS_ACCESS_KEY" {
    type    = string                             # Specifies the variable type
    default = "AKIA4DMVQH6CVTO3ET5K"             # Default AWS Access Key (Note: should be stored securely)
}

# AWS Secret Key: Also used for authentication (kept without default for security reasons)
variable "AWS_SECRET_KEY" {
    # Intentionally left without default for security; user must pass this securely
}

# AWS Region to deploy resources into
variable "AWS_REGION" {
  default = "us-east-1"                          # Default region where Terraform deploys resources
}

# Security Group IDs to attach to EC2 instances
variable "Security_Group" {
    type    = list                               # Specifies the variable type as a list
    default = ["sg-073d1526688374c13"]           # Example security group(s) to apply to EC2
}

# AMI IDs mapped per region to ensure the correct OS image is selected dynamically
variable "AMIS" {
    type = map                                   # Map data type to associate regions with AMI IDs
    default = {
        us-east-1 = "ami-0e9bbd70d26d7cf4f"      # Amazon Linux AMI in US East (N. Virginia)
        us-east-2 = "ami-05692172625678b4e"      # Amazon Linux AMI in US East (Ohio)
        us-west-2 = "ami-0352d5a37fb4f603f"      # Amazon Linux AMI in US West (Oregon)
        us-west-1 = "ami-0f40c8f97004632f9"      # Amazon Linux AMI in US West (N. California)
    }
}

# Path to the private key file for SSH authentication with EC2
variable "PATH_TO_PRIVATE_KEY" {
  default = "levelup_key"                        # Path to private key file (should not have .pem if already configured)
}

# Path to the public key file to upload to AWS as part of the key pair
variable "PATH_TO_PUBLIC_KEY" {
  default = "levelup_key.pub"                    # Public key used to generate AWS key pair
}

# SSH username for connecting to the EC2 instance
variable "INSTANCE_USERNAME" {
  default = "ubuntu"                             # Common default for Ubuntu-based AMIs; adjust as needed
}

