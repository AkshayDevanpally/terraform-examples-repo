# ============================================================================================
# Purpose:
# This script creates a secure EC2 instance on AWS inside a specific VPC and subnet.
# It uses a key pair for SSH access and associates a security group that allows SSH.
#
# Key Resources:
# - aws_key_pair: Registers your local SSH public key with AWS
# - aws_instance: Provisions an EC2 instance with the registered key and security group
# - output: Displays the EC2 instance’s public IP after deployment
# ============================================================================================

# --------------------------------------------------------
# Create an AWS Key Pair for secure SSH access
# --------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                        # AWS will register the key with this name
  public_key = file(var.PATH_TO_PUBLIC_KEY)         # Loads your SSH public key from local path
}

# --------------------------------------------------------
# Launch an EC2 instance in the specified subnet and AZ
# --------------------------------------------------------
resource "aws_instance" "MyFirstInstnace" {
  ami                         = lookup(var.AMIS, var.AWS_REGION)         # AMI ID dynamically selected based on region
  instance_type               = "t2.micro"                               # Free-tier eligible instance type
  availability_zone           = "us-east-1a"                             # Availability zone for the EC2 instance
  key_name                    = aws_key_pair.levelup_key.key_name        # Uses the created key for SSH login
  vpc_security_group_ids      = [aws_security_group.allow-levelup-ssh.id]# Security group allowing SSH access
  subnet_id                   = aws_subnet.levelupvpc-public-1.id        # Attach to a specific public subnet

  tags = {
    Name = "custom_instance"                                            # Assign a human-readable name tag
  }
}

# --------------------------------------------------------
# Output the public IP of the created EC2 instance
# --------------------------------------------------------
output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip                        # Makes the public IP easy to view
}

