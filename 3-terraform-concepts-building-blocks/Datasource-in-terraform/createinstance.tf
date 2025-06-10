# ============================================================================================
# Purpose:
# Provision an EC2 instance using the latest Amazon Linux 2 AMI and a specific availability zone 
# retrieved dynamically using Terraform data sources. Also, log the private IP of the instance 
# locally and output its public IP.

# Key Concepts:
# - Terraform data sources allow you to query existing AWS resources
# - Dynamically fetch the latest Amazon Linux 2 AMI and available zones for deployment
# - Use provisioners to execute local commands after resource creation
# command to get owner id in aws cli : ws ec2 describe-images --image-ids ami-0dc3a08bd93f84a35 --query "Images[*].{OwnerId:OwnerId}" --output text
# ============================================================================================

# Data source: Get a list of all available availability zones in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source: Find the most recent Amazon Linux 2 AMI (Free Tier eligible, HVM, x86_64)
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["137112412989"] # Amazon official

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Create an EC2 instance using the fetched data
resource "aws_instance" "MyFirstInstance" {
  ami               = data.aws_ami.amazon_linux_2.id
  instance_type     = "t2.micro"
  availability_zone = data.aws_availability_zones.available.names[1]

  provisioner "local-exec" {
    command = "echo ${aws_instance.MyFirstInstance.private_ip} >> my_private_ips.txt"
  }

  tags = {
    Name = "amazon-linux-instance"
  }
}

# Output the public IP of the instance
output "public_ip" {
  value = aws_instance.MyFirstInstance.public_ip
}

