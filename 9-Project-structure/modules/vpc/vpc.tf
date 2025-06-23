# ============================================================================================
#  Custom VPC Setup using Terraform AWS Modules
# This configuration creates a custom Virtual Private Cloud (VPC) with public and private subnets
# across 3 availability zones, using the community-maintained terraform-aws-vpc module.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# VPC Module Block
# Creates a VPC with 3 public and 3 private subnets distributed across multiple AZs.
# --------------------------------------------------------------------------------------------
module "levelup-vpc" {
  source = "terraform-aws-modules/vpc/aws"  # Reusable AWS VPC module

  name = "vpc-${var.ENVIRONMENT}"           # Name of the VPC based on environment
  cidr = "10.0.0.0/16"                      # CIDR block for the whole VPC

  # Availability Zones (Dynamically constructed using the provided AWS region)
  azs = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]

  # Subnet CIDRs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false               # No NAT gateway needed (for this setup)
  enable_vpn_gateway = false               # No VPN gateway required

  tags = {
    Terraform   = "true"                   # Helps identify Terraform-managed resources
    Environment = var.ENVIRONMENT          # Tagging the environment (e.g., dev, prod)
  }
}

# --------------------------------------------------------------------------------------------
#  Outputs
# Return key information after Terraform apply for use elsewhere (or just for visibility).
# --------------------------------------------------------------------------------------------

# Output the created VPC ID
output "my_vpc_id" {
  description = "VPC ID"
  value       = module.levelup-vpc.vpc_id
}

# Output the list of private subnet IDs
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.levelup-vpc.private_subnets
}

# Output the list of public subnet IDs
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.levelup-vpc.public_subnets
}

