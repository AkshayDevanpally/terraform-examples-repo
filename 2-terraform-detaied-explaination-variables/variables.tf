# ============================================================================================
# 📘 Purpose:
# Define and centralize all key variables used across Terraform AWS infrastructure code. 
# This allows for reusable, modular, and environment-flexible infrastructure provisioning.

# 🧠 Key Concepts:
# - Terraform variables: used to parameterize configuration for flexibility
# - Access credentials: required for AWS authentication
# - Region and AMI selection: allows code to work across multiple AWS regions
# - Security groups: reusable lists to control access to EC2 or other services
# ============================================================================================

variable "AWS_ACCESS_KEY" {
  # No default for security reasons; value should be provided at runtime or via secrets management
}
variable "AWS_SECRET_KEY" {
  # No default; sensitive information should not be hardcoded
}
variable "AWS_REGION" {
  default = "us-east-1"  # can be overridden when running terraform
}

variable "Security_Group" {
  type = list  # Specifies the type as a list of strings
  default = ["sg-24076", "sg-90890", "sg-456789"]  # 📦 Example SGs, replace with actual IDs
}
 
variable "AMIS" {
  type = map  # Maps each region to a specific AMI ID
  default = {
    us-east-1 = "ami-0f40c8f97004632f9"   # Example AMI for US East (N. Virginia)
    us-east-2 = "ami-05692172625678b4e"   # Example AMI for US East (Ohio)
    us-west-2 = "ami-0352d5a37fb4f603f"   # Example AMI for US West (Oregon)
    us-west-1 = "ami-0f40c8f97004632f9"   # Example AMI for US West (N. California)
  }
}

