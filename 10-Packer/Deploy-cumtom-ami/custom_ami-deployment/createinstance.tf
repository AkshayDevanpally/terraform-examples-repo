# ---------------------------------------------------------------------------------------------
# Create EC2 Instance using a Custom VPC defined in a separate module
# ---------------------------------------------------------------------------------------------

# VPC Module - Fetch VPC and subnet outputs from the module
module "develop-vpc" {
  source      = "../modules/vpc"            # Path to your custom VPC module
  ENVIRONMENT = var.ENVIRONMENT             # Environment (e.g., dev, prod) passed as a variable
  AWS_REGION  = var.AWS_REGION              # Region where the resources will be created
}

# ---------------------------------------------------------------------------------------------
# AWS Provider Configuration
# ---------------------------------------------------------------------------------------------
provider "aws" {
  region = var.AWS_REGION                   # AWS region used for provisioning resources
}

# ---------------------------------------------------------------------------------------------
# Key Pair Resource
# Generates a named SSH key pair using a public key file
# ---------------------------------------------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                # Key name to reference in EC2
  public_key = file(var.public_key_path)    # Reads local public key file (e.g., ~/.ssh/id_rsa.pub)
}

# ---------------------------------------------------------------------------------------------
# Security Group - Allow SSH from anywhere
# Used to connect to EC2 instances over port 22
# ---------------------------------------------------------------------------------------------
resource "aws_security_group" "allow-ssh" {
  vpc_id      = module.develop-vpc.my_vpc_id         # Attach SG to the custom VPC from the module
  name        = "allow-ssh-${var.ENVIRONMENT}"       # SG name based on environment
  description = "security group that allows ssh traffic"

  egress {
    from_port   = 0                                  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22                                 # Allow SSH access from anywhere
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENVIRONMENT                   # Tag the environment
  }
}

# ---------------------------------------------------------------------------------------------
# EC2 Instance Resource
# Launches a single EC2 instance inside the custom VPC using provided AMI and subnet
# ---------------------------------------------------------------------------------------------
resource "aws_instance" "my-instance" {
  ami           = var.AMI_ID                        # AMI ID provided via variable (e.g., Ubuntu)
  instance_type = var.INSTANCE_TYPE                 # EC2 type (e.g., t2.micro)

  subnet_id              = element(module.develop-vpc.public_subnets, 0)  # Use first public subnet
  availability_zone      = "${var.AWS_REGION}a"                           # AZ where instance will launch
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]             # Attach SSH SG
  key_name               = aws_key_pair.levelup_key.key_name             # SSH key to access instance

  tags = {
    Name         = "instance-${var.ENVIRONMENT}"    # Custom name for the instance
    Environmnent = var.ENVIRONMENT                  # Tag for identifying environment
  }
}

