# ============================================================================================
# Terraform Variables for AWS VPC Configuration
# This file defines configurable inputs to make your infrastructure reusable and dynamic.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# AWS Credentials and Region
# --------------------------------------------------------------------------------------------

variable "AWS_ACCESS_KEY" {
  type    = string
  default = "AKIA4DMVQH6CVTO3ET5K"  
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"             # AWS region where resources will be deployed (e.g., Ohio).
}

# --------------------------------------------------------------------------------------------
# VPC Metadata and Addressing
# --------------------------------------------------------------------------------------------

variable "vpcname" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""                  # Provide a meaningful VPC name like "levelup-vpc"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "0.0.0.0/0"         
}

# --------------------------------------------------------------------------------------------
# VPC Feature Toggles
# --------------------------------------------------------------------------------------------

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"           # Options: "default" (shared) or "dedicated" (dedicated hardware)
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false               # Required for public instances to resolve domain names
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true                # Internal DNS resolution for the VPC (recommended)
}

# --------------------------------------------------------------------------------------------
# ClassicLink Options (Legacy Feature)
# --------------------------------------------------------------------------------------------

variable "enable_classiclink" {
  description = "Enable ClassicLink (only for legacy EC2-Classic accounts/regions)"
  type        = bool
  default     = null                # Usually set to false unless EC2-Classic is required
}

variable "enable_classiclink_dns_support" {
  description = "Enable DNS support for ClassicLink"
  type        = bool
  default     = null                # Applies only if ClassicLink is enabled
}

# --------------------------------------------------------------------------------------------
# IPv6 Support
# --------------------------------------------------------------------------------------------

variable "enable_ipv6" {
  description = "Request an Amazon-provided IPv6 CIDR block for the VPC"
  type        = bool
  default     = false               # Set to true if IPv6 addressing is needed
}

# --------------------------------------------------------------------------------------------
# Environment Tag
# --------------------------------------------------------------------------------------------

variable "vpcenvironment" {
  description = "Tag representing the environment (e.g., dev, staging, prod)"
  type        = string
  default     = "Development"       # Helpful for resource classification and cost tracking
}

