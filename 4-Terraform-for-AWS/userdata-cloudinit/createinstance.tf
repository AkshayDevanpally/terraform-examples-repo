# ============================================================================================
# Purpose:
# This Terraform script provisions an EC2 instance in AWS and sets it up to run initialization
# commands using a cloud-init configuration. A key pair is created for SSH access, and user_data 
# is supplied using a processed cloud-init template.
#
# Key Components:
# - aws_key_pair: Registers an existing SSH public key with AWS
# - aws_instance: Creates an EC2 instance using the defined key pair and user_data
# - output: Displays the instance’s public IP after deployment
# ============================================================================================

# --------------------------------------------------------
# Create an SSH key pair using the local public key file
# --------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                    # The name assigned to the key pair in AWS
  public_key = file(var.PATH_TO_PUBLIC_KEY)     # Reads the public key from the specified path
}

# --------------------------------------------------------
# Provision an EC2 instance with cloud-init user data
# --------------------------------------------------------
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)      # Fetches appropriate AMI based on region
  instance_type     = "t2.micro"                            # Free-tier eligible instance size
  availability_zone = "us-east-1a"                          # Zone where instance will be deployed
  key_name          = aws_key_pair.levelup_key.key_name     # Attach the created key pair for SSH

  # Inject cloud-init configuration to install software or configure the instance
  user_data = data.template_cloudinit_config.install-apache-config.rendered

  tags = {
    Name = "custom_instance"                                # Assign a human-readable tag
  }
}

# --------------------------------------------------------
# Output the public IP of the newly created EC2 instance
# --------------------------------------------------------
output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip           # Makes the public IP accessible via CLI/UI
}

