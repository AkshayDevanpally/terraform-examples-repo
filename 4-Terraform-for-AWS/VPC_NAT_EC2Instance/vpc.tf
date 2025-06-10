# ============================================================================================
# ✅ Purpose:
# This Terraform configuration sets up a complete custom Virtual Private Cloud (VPC)
# with three public and three private subnets across different Availability Zones (AZs),
# an internet gateway, and a public route table with subnet associations.

# 🧠 Key Concepts:
# - VPC: Isolated network for AWS resources
# - Subnets: Public (internet accessible) and Private (internal)
# - Internet Gateway: Enables internet access for public subnets
# - Route Tables: Manage traffic routing in subnets
# - AZ Distribution: High availability across multiple zones
# ============================================================================================


# Create a custom AWS VPC
resource "aws_vpc" "levelupvpc" {
  cidr_block           = "10.0.0.0/16"        # Large network range for all subnets in this VPC
  instance_tenancy     = "default"            # Default tenancy means shared hardware
  enable_dns_support   = "true"               # Allows instances to resolve DNS names
  enable_dns_hostnames = "true"               # Required if using public DNS for EC2
  enable_classiclink   = "false"              # Not using ClassicLink (for legacy setups)

  tags = {
    Name = "levelupvpc"                       # Name tag for the VPC
  }
}

# =======================
# Public Subnets
# =======================

# Public Subnet in AZ us-east-1a
resource "aws_subnet" "levelupvpc-public-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.1.0/24"        # Subnet range within VPC
  map_public_ip_on_launch = "true"              # Automatically assigns public IPs to instances
  availability_zone       = "us-east-1a"

  tags = {
    Name = "levelupvpc-public-1"
  }
}

# Public Subnet in AZ us-east-1b
resource "aws_subnet" "levelupvpc-public-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "levelupvpc-public-2"
  }
}

# Public Subnet in AZ us-east-1c
resource "aws_subnet" "levelupvpc-public-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "levelupvpc-public-3"
  }
}

# =======================
# Private Subnets
# =======================

# Private Subnet in AZ us-east-1a
resource "aws_subnet" "levelupvpc-private-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"             # Instances do not get public IPs
  availability_zone       = "us-east-1a"

  tags = {
    Name = "levelupvpc-private-1"
  }
}

# Private Subnet in AZ us-east-1b
resource "aws_subnet" "levelupvpc-private-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "levelupvpc-private-2"
  }
}

# Private Subnet in AZ us-east-1c
resource "aws_subnet" "levelupvpc-private-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "levelupvpc-private-3"
  }
}

# =======================
# Internet Gateway
# =======================

# Create Internet Gateway to allow outbound access for public subnets
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelupvpc.id

  tags = {
    Name = "levelup-gw"
  }
}

# =======================
# Route Table for Public Subnets
# =======================

# Create a Route Table for public subnets and add route to internet via IGW
resource "aws_route_table" "levelup-public" {
  vpc_id = aws_vpc.levelupvpc.id

  route {
    cidr_block = "0.0.0.0/0"                      # Default route to all destinations
    gateway_id = aws_internet_gateway.levelup-gw.id
  }

  tags = {
    Name = "levelup-public-1"
  }
}

# =======================
# Associate Public Subnets with Public Route Table
# =======================

resource "aws_route_table_association" "levelup-public-1-a" {
  subnet_id      = aws_subnet.levelupvpc-public-1.id
  route_table_id = aws_route_table.levelup-public.id
}

resource "aws_route_table_association" "levelup-public-2-a" {
  subnet_id      = aws_subnet.levelupvpc-public-2.id
  route_table_id = aws_route_table.levelup-public.id
}

resource "aws_route_table_association" "levelup-public-3-a" {
  subnet_id      = aws_subnet.levelupvpc-public-3.id
  route_table_id = aws_route_table.levelup-public.id
}

