# ============================================================================================
# Purpose:
# Define essential Terraform variables required for AWS infrastructure provisioning.
# This includes credentials, region, AMI mappings, and security group configurations.

# Key Concepts:
# - Variables help make Terraform configurations reusable and modular.
# - AWS credentials and region are dynamically passed for flexibility.
# - Lists and maps are used to support multiple security groups and region-based AMI lookups.
# ============================================================================================

# AWS Access Key
# Used for programmatic authentication to AWS
variable "AWS_ACCESS_KEY" {
    type    = string
    default = "AKIA4DMVQH6CVTO3ET5K"
    # This is the AWS Access Key ID. It is sensitive and should be stored securely using environment variables or a credentials file.
}

# AWS Secret Key
# This variable will store the corresponding AWS Secret Access Key
variable "AWS_SECRET_KEY" {
    # No default provided for security. It should be passed securely using a tfvars file or environment variable.
}

# AWS Region
# Specifies the region where the AWS resources will be deployed
variable "AWS_REGION" {
  default = "us-east-1"
  # Default set to US East (N. Virginia). This can be overridden for deploying to other regions.
}

# Security Group IDs
# A list of security group IDs to attach to the EC2 instance
variable "Security_Group" {
    type    = list
    default = ["sg-073d1526688374c13"]
    # These IDs represent pre-created security groups that define firewall rules for your instances.
}

# AMIs for different regions
# A mapping of AWS regions to Amazon Machine Images (AMIs)
variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-0e9bbd70d26d7cf4f"
        us-east-2 = "ami-05692172625678b4e"
        us-west-2 = "ami-0352d5a37fb4f603f"
        us-west-1 = "ami-0f40c8f97004632f9"
    }
    # This map allows your Terraform code to choose the correct AMI automatically based on the region specified.
}

