# ============================================================================================
# VPC Module Invocation for Development Environment
# This block reuses a custom VPC module to provision a VPC tailored for the dev environment.
# ============================================================================================

module "dev-vpc" {
  source = "../../custom_vpc"                                # Path to the custom VPC module (relative directory)

  vpcname              = "dev01-vpc"                         # Unique name identifier for the VPC
  cidr                 = "10.0.2.0/24"                       # CIDR block for the VPC (choose according to your network plan)
  enable_dns_support   = "true"                              # Enables internal DNS resolution (recommended)
  enable_ipv6          = "true"                              # Enables IPv6 support (Amazon will assign an IPv6 CIDR block)
  vpcenvironment       = "Development-Engineering"           # Used for environment tagging (e.g., dev, staging, prod)
}

