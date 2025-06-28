#################################################################
# Purpose and Overview:
# This Terraform variables file defines all the input variables
# required for provisioning a custom AWS VPC architecture.
#
# These include region settings, VPC CIDR blocks, public/private 
# subnet configurations, and the environment tag used for naming.
#################################################################

# AWS region where resources will be provisioned
variable "AWS_REGION" {
  type        = string
  default     = "us-east-1"  # Default to North Virginia region
}

# CIDR block for the main VPC
variable "LEVELUP_VPC_CIDR_BLOC" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # Allows for a large private IP range
}

# CIDR block for the first public subnet
variable "LEVELUP_VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {
  description = "The CIDR block for Public Subnet 1"
  type        = string
  default     = "10.0.101.0/24"
}

# CIDR block for the second public subnet
variable "LEVELUP_VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {
  description = "The CIDR block for Public Subnet 2"
  type        = string
  default     = "10.0.102.0/24"
}

# CIDR block for the first private subnet
variable "LEVELUP_VPC_PRIVATE_SUBNET1_CIDR_BLOCK" {
  description = "The CIDR block for Private Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

# CIDR block for the second private subnet
variable "LEVELUP_VPC_PRIVATE_SUBNET2_CIDR_BLOCK" {
  description = "The CIDR block for Private Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

# Environment name used in resource naming (e.g., Development, Production)
variable "ENVIRONMENT" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = "Development"
}
