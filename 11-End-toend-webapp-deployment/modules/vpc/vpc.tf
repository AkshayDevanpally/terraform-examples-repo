#################################################################
# Purpose and Overview:
# This Terraform script provisions a custom VPC setup in AWS.
# It includes:
# - One VPC with DNS support
# - Two public subnets and two private subnets across 2 AZs
# - Internet Gateway for public subnets
# - NAT Gateway for private subnets to access the internet
# - Elastic IP for the NAT Gateway
# - Route tables for public and private subnets
# - Subnet-to-route table associations
#
# This setup is suitable for hosting applications that require 
# public-facing resources (e.g., web servers) and isolated backend 
# resources (e.g., databases).
#################################################################

# Retrieve list of available availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create main VPC with DNS support enabled
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.LEVELUP_VPC_CIDR_BLOC
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

# Create public subnet 1 in first availability zone
resource "aws_subnet" "levelup_vpc_public_subnet_1" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.LEVELUP_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"  # Automatically assign public IP

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-1"
  }
}

# Create public subnet 2 in second availability zone
resource "aws_subnet" "levelup_vpc_public_subnet_2" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.LEVELUP_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-2"
  }
}

# Create private subnet 1 in first availability zone
resource "aws_subnet" "levelup_vpc_private_subnet_1" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-1"
  }
}

# Create private subnet 2 in second availability zone
resource "aws_subnet" "levelup_vpc_private_subnet_2" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-2"
  }
}

# Attach internet gateway to VPC for public internet access
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-internet-gateway"
  }
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "levelup_nat_eip" {
  depends_on = [aws_internet_gateway.levelup_igw]  # Ensure IGW is created first
}

# Create NAT Gateway in public subnet 1 for outbound access from private subnets
resource "aws_nat_gateway" "levelup_ngw" {
  allocation_id = aws_eip.levelup_nat_eip.id
  subnet_id     = aws_subnet.levelup_vpc_public_subnet_1.id
  depends_on    = [aws_internet_gateway.levelup_igw]

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-vpc-NAT-gateway"
  }
}

# Route table for public subnets to access internet via IGW
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

# Route table for private subnets to access internet via NAT
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

# Associate route table with public subnet 1
resource "aws_route_table_association" "to_public_subnet1" {
  subnet_id      = aws_subnet.levelup_vpc_public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

# Associate route table with public subnet 2
resource "aws_route_table_association" "to_public_subnet2" {
  subnet_id      = aws_subnet.levelup_vpc_public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# Associate private subnet 1 with private route table
resource "aws_route_table_association" "to_private_subnet1" {
  subnet_id      = aws_subnet.levelup_vpc_private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# Associate private subnet 2 with private route table
resource "aws_route_table_association" "to_private_subnet2" {
  subnet_id      = aws_subnet.levelup_vpc_private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

# AWS Provider configuration
provider "aws" {
  region = var.AWS_REGION
}

# Output VPC and Subnet IDs for use in other modules or reference
output "my_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.levelup_vpc.id
}

output "private_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_private_subnet_1.id
}

output "private_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_private_subnet_2.id
}

output "public_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_public_subnet_1.id
}

output "public_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_private_subnet_2.id
}


