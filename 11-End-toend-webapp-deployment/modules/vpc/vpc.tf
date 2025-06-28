#####################################################################################################
# Purpose and Overview:
# This Terraform script provisions a complete VPC networking environment in AWS, including:
# - A custom VPC
# - Two public subnets and two private subnets across different availability zones
# - An Internet Gateway for public access
# - A NAT Gateway for private subnet internet access
# - Route tables and associations for directing traffic
# - Outputs for downstream module consumption or infrastructure references
#####################################################################################################

# AWS provider configuration using a region variable
provider "aws" {
  region = var.AWS_REGION
}

# Fetch the list of available availability zones for subnet placement
data "aws_availability_zones" "available" {
  state = "available"
}

# Create the VPC with DNS support and hostname resolution
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.LEVELUP_VPC_CIDR_BLOC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

# Public Subnet 1 in first AZ with public IP auto-assignment
resource "aws_subnet" "levelup_vpc_public_subnet_1" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.LEVELUP_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-1"
  }
}

# Public Subnet 2 in second AZ
resource "aws_subnet" "levelup_vpc_public_subnet_2" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.LEVELUP_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-2"
  }
}

# Private Subnet 1 in first AZ
resource "aws_subnet" "levelup_vpc_private_subnet_1" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-1"
  }
}

# Private Subnet 2 in second AZ
resource "aws_subnet" "levelup_vpc_private_subnet_2" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-2"
  }
}

# Internet Gateway for external internet access from public subnets
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-internet-gateway"
  }
}

# Allocate Elastic IP for NAT Gateway (used for outbound internet from private subnets)
resource "aws_eip" "levelup_nat_eip" {
  depends_on = [aws_internet_gateway.levelup_igw]
}

# NAT Gateway placed in public subnet to allow internet access from private subnets
resource "aws_nat_gateway" "levelup_ngw" {
  allocation_id = aws_eip.levelup_nat_eip.id
  subnet_id     = aws_subnet.levelup_vpc_public_subnet_1.id
  depends_on    = [aws_internet_gateway.levelup_igw]

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-NAT-gateway"
  }
}

# Public route table with route to Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.levelup_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup_igw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-public-route-table"
  }
}

# Private route table with route to NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.levelup_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.levelup_ngw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-private-route-table"
  }
}

# Associate public route table with public subnet 1
resource "aws_route_table_association" "to_public_subnet1" {
  subnet_id      = aws_subnet.levelup_vpc_public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

# Associate public route table with public subnet 2
resource "aws_route_table_association" "to_public_subnet2" {
  subnet_id      = aws_subnet.levelup_vpc_public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# Associate private route table with private subnet 1
resource "aws_route_table_association" "to_private_subnet1" {
  subnet_id      = aws_subnet.levelup_vpc_private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# Associate private route table with private subnet 2
resource "aws_route_table_association" "to_private_subnet2" {
  subnet_id      = aws_subnet.levelup_vpc_private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

###########################################
# Outputs for external use (e.g., modules)
###########################################

# VPC ID output
output "my_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.levelup_vpc.id
}

# Private subnet 1 ID output
output "private_subnet1_id" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.levelup_vpc_private_subnet_1.id
}

# Private subnet 2 ID output
output "private_subnet2_id" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.levelup_vpc_private_subnet_2.id
}

# Public subnet 1 ID output
output "public_subnet1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.levelup_vpc_public_subnet_1.id
}

# Public subnet 2 ID output (corrected to refer to public subnet)
output "public_subnet2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.levelup_vpc_public_subnet_2.id
}

