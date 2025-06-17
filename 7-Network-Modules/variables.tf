# ============================================================================================
# 📦 Input Variables for EC2 + VPC Terraform Configuration
# These variables define region, instance specifications, and tagging metadata.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# 🌍 AWS Region
# Defines where the infrastructure will be deployed.
# --------------------------------------------------------------------------------------------
variable "region" {
  default = "us-east-1"  # N.virginia region
}

# --------------------------------------------------------------------------------------------
# 🔐 Public Key Path
# Local path to the SSH public key used for EC2 instance login.
# --------------------------------------------------------------------------------------------
variable "public_key_path" {
  description = "Path to the SSH public key (.pub file) for the EC2 instance"
  default     = "~/.ssh/levelup_key.pub"
}

# --------------------------------------------------------------------------------------------
# 💽 AMI ID for EC2
# Amazon Machine Image ID used to launch the instance. Update as needed per region.
# --------------------------------------------------------------------------------------------
variable "instance_ami" {
  description = "AMI ID to use for the EC2 instance (e.g., Amazon Linux)"
  default     = "ami-0e9bbd70d26d7cf4f"
}

# --------------------------------------------------------------------------------------------
# 🖥️ EC2 Instance Type
# Specifies the instance size/type (e.g., t2.micro for free tier).
# --------------------------------------------------------------------------------------------
variable "instance_type" {
  description = "EC2 instance type (e.g., t2.micro)"
  default     = "t2.micro"
}

# --------------------------------------------------------------------------------------------
# 🏷️ Environment Tag
# Tag used to identify the environment (e.g., Development, Staging, Production).
# --------------------------------------------------------------------------------------------
variable "environment_tag" {
  description = "Tag that defines the deployment environment"
  default     = "Production"
}

