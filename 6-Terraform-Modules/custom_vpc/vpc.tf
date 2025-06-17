# ============================================================================================
# VPC Configuration
# This resource creates a Virtual Private Cloud (VPC) with custom DNS, tenancy, and optional IPv6.
# ============================================================================================

resource "aws_vpc" "aws_vpc_levelup" {

  # CIDR block defining the IP address range for the VPC (e.g., 10.0.0.0/16)
  cidr_block = var.cidr

  # Tenancy option: "default" (shared hardware) or "dedicated" (dedicated hardware for EC2)
  instance_tenancy = var.instance_tenancy

  # Enable DNS hostnames for instances launched into this VPC
  enable_dns_hostnames = var.enable_dns_hostnames

  # Enable internal DNS resolution within the VPC
  enable_dns_support = var.enable_dns_support

  # Assign an automatically generated IPv6 CIDR block (if set to true)
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  # Tags to help identify and manage the VPC
  tags = {
    name        = var.vpcname         # Logical name tag for the VPC (e.g., "levelup-vpc")
    environment = var.vpcenvironment  # Environment tag (e.g., "dev", "prod")
  }
}

