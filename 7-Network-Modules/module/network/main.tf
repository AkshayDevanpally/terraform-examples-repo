# ============================================================================================
# 🌐 VPC Infrastructure Setup for "LevelUp" Project
# This configuration creates a basic network environment including a VPC, public subnet,
# internet gateway, routing, and a security group for SSH access.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# 🔶 VPC Resource
# Creates a Virtual Private Cloud (VPC) with DNS resolution and hostname support enabled.
# --------------------------------------------------------------------------------------------
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.cidr_vpc                         # CIDR block defining IP range of the VPC
  enable_dns_support   = true                                 # Enables DNS resolution within the VPC
  enable_dns_hostnames = true                                 # Allows assigning DNS hostnames to instances

  tags = {
    Environment = var.environment_tag                         # Environment tag (e.g., Dev, QA, Prod)
  }
}

# --------------------------------------------------------------------------------------------
# 🌐 Internet Gateway
# Enables outbound internet access from public subnets.
# --------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id                             # Attaches IGW to the above VPC

  tags = {
    Environment = var.environment_tag
  }
}

# --------------------------------------------------------------------------------------------
# 📦 Public Subnet
# A subnet within the VPC with automatic public IP assignment for instances.
# --------------------------------------------------------------------------------------------
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.cidr_subnet                   # Subnet range (must be a subset of VPC range)
  map_public_ip_on_launch = true                              # Automatically assigns public IPs to instances
  availability_zone       = var.availability_zone             # AWS Availability Zone (e.g., us-east-1a)

  tags = {
    Environment = var.environment_tag
  }
}

# --------------------------------------------------------------------------------------------
# 🛣️ Route Table for Public Subnet
# Directs traffic destined for the internet to the internet gateway.
# --------------------------------------------------------------------------------------------
resource "aws_route_table" "levelup_rtb_public" {
  vpc_id = aws_vpc.levelup_vpc.id

  route {
    cidr_block = "0.0.0.0/0"                                  # Route all IPv4 internet traffic
    gateway_id = aws_internet_gateway.levelup_igw.id          # Send it to the Internet Gateway
  }

  tags = {
    Environment = var.environment_tag
  }
}

# --------------------------------------------------------------------------------------------
# 🔗 Route Table Association
# Associates the public route table with the public subnet.
# --------------------------------------------------------------------------------------------
resource "aws_route_table_association" "levelup_rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.levelup_rtb_public.id
}

# --------------------------------------------------------------------------------------------
# 🔐 Security Group
# A firewall to control inbound and outbound traffic to instances.
# --------------------------------------------------------------------------------------------
resource "aws_security_group" "levelup_sg_22" {
  name   = "levelup_sg_22"
  vpc_id = aws_vpc.levelup_vpc.id

  # ✅ Inbound Rule: Allow SSH (port 22) from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                             
  }

  # ✅ Outbound Rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                                       # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment_tag
  }
}

