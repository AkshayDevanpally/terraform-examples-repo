# ============================================================================================
# VPC Module for Development QA Environment
# This module call provisions a VPC specifically for QA testing under the dev environment.
# ============================================================================================

module "dev-qa-vpc" {
  source = "../../custom_vpc"                                # Relative path to the reusable VPC module

  vpcname        = "dev02-qa-vpc"                            # Unique identifier name for the QA VPC
  cidr           = "10.0.1.0/24"                             # CIDR block assigned to the VPC

  enable_dns_support             = "true"                   # Enables DNS resolution within the VPC
  enable_classiclink             = "false"                  # Disables deprecated ClassicLink feature
  enable_classiclink_dns_support = "false"                  # Disables DNS for ClassicLink (no longer used)
  enable_ipv6                    = "false"                  # Disables IPv6 CIDR assignment (IPv4 only)

  vpcenvironment = "Development-QA-Engineering"              # Tagging for environment clarity (QA use case)

  AWS_REGION     = "us-east-1"                               # AWS region to deploy this VPC into
}

