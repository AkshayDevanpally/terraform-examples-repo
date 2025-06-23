# ===================================================================================================
# EC2 Instance Deployment Using Custom VPC
# This configuration sets up a key pair, security group, and launches an EC2 instance in a given VPC.
# ===================================================================================================

# ---------------------------------------------------------------------------------------------------
# Key Pair
# This resource imports a local SSH public key into AWS so you can access the EC2 instance via SSH.
# ---------------------------------------------------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                      # Name for the key pair in AWS
  public_key = file(var.public_key_path)          # Load the public key from a local file path
}

# ---------------------------------------------------------------------------------------------------
# Security Group
# Defines a security group that allows SSH (port 22) access from anywhere.
# ---------------------------------------------------------------------------------------------------
resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.VPC_ID                        # Attach security group to the given VPC
  name        = "allow-ssh-${var.ENVIRONMENT}"    # Dynamic name based on environment
  description = "security group that allows ssh traffic"

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENVIRONMENT                # Tag the environment (e.g., dev, prod)
  }
}

# ---------------------------------------------------------------------------------------------------
# EC2 Instance
# Launches a single EC2 instance in the specified public subnet using the defined key and security group.
# ---------------------------------------------------------------------------------------------------
resource "aws_instance" "my-instance" {
  ami                         = lookup(var.AMIS, var.AWS_REGION)         # Use AMI based on selected region
  instance_type               = var.INSTANCE_TYPE                        # Define instance size (e.g., t2.micro)
  subnet_id                   = element(var.PUBLIC_SUBNETS, 0)           # Launch in the first public subnet
  availability_zone           = "${var.AWS_REGION}a"                     # Place instance in a specific AZ
  vpc_security_group_ids      = [aws_security_group.allow-ssh.id]        # Attach the SSH security group
  key_name                    = aws_key_pair.levelup_key.key_name        # Use imported key for SSH access

  tags = {
    Name         = "instance-${var.ENVIRONMENT}"                         # Name tag for instance
    Environmnent = var.ENVIRONMENT
  }
}



