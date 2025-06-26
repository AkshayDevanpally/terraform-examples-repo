# -------------------------------------------------------------------------------
# Create a Custom VPC using the terraform-aws-modules/vpc/aws community module
# -------------------------------------------------------------------------------
module "levelup-vpc" {
  source = "terraform-aws-modules/vpc/aws"             # Uses official reusable VPC module from Terraform registry

  name = "vpc-${var.ENVIRONMENT}"                      # VPC name with environment suffix (e.g., vpc-development)

  cidr = "10.0.0.0/16"                                 # Primary CIDR block for the VPC

  # Availability Zones and Subnets
  azs             = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]   # 3 AZs in the region
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]                         # Private subnet ranges
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]                   # Public subnet ranges

  # VPC Feature Settings
  enable_nat_gateway = false                          # NAT Gateway not created (used for private subnet internet access)
  enable_vpn_gateway = false                          # VPN Gateway not created

  # Tags applied to all resources created by this module
  tags = {
    Terraform   = "true"
    Environment = var.ENVIRONMENT                     # Tag with environment (e.g., dev, prod)
  }
}

# -------------------------------------------------------------------------------
# Outputs: Export useful values from the VPC module to use in other modules/resources
# -------------------------------------------------------------------------------

# Output the VPC ID created by the module
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

