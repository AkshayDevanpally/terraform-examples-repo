# ============================================================================================
# 📘 Purpose:
# This Terraform configuration creates a key pair and launches an EC2 instance 
# in a specified public subnet using a fetched Amazon Linux 2 AMI.

# 🧠 Key Concepts:
# - AWS EC2 provisioning with a custom key pair
# - Referencing data sources and existing infrastructure
# - Attaching security groups and deploying into a VPC subnet
# ============================================================================================

# Define an AWS Key Pair resource to allow SSH access to the EC2 instance.
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                        # Name of the key pair shown in AWS Console
  public_key = file(var.PATH_TO_PUBLIC_KEY)         # Path to the local public key file (.pub)
}

# Create an EC2 instance using a fetched Amazon Linux 2 AMI and the above key pair.
resource "aws_instance" "MyFirstInstance" {
  ami                         = data.aws_ami.amazon_linux_2.id       # Use the most recent Amazon Linux 2 AMI from a data source
  instance_type               = "t2.micro"                            # Use a free-tier eligible instance type
  key_name                    = aws_key_pair.levelup_key.key_name     # Reference the key pair defined earlier

  vpc_security_group_ids      = [aws_security_group.allow-levelup-ssh.id]  # Attach the defined SSH security group
  subnet_id                   = aws_subnet.levelupvpc-public-2.id     # Deploy into the specified public subnet

  tags = {
    Name = "custom_instance"                                          # Assign a custom name tag to the instance
  }
}

