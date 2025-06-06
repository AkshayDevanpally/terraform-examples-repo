# ============================================================================================
# Purpose:
# This configuration provisions an EC2 instance on AWS, attaches an SSH key pair,
# runs a shell script to install Nginx using remote provisioning, and tags the instance.

# Key Concepts:
# - AWS Key Pair: Enables SSH access to EC2 instances
# - EC2 Instance: Creates a virtual machine using a specific AMI and instance type
# - Provisioners: Used to copy files and execute commands on the instance after creation
# - Connections: Required for provisioners to authenticate and connect via SSH
# ============================================================================================

# Create an AWS key pair using a local public key file
resource "aws_key_pair" "levelup_key" {
    key_name   = "levelup_key"                         # The name used for the key in AWS
    public_key = file(var.PATH_TO_PUBLIC_KEY)          # Loads the public key from a specified file path
}

# Create an EC2 instance using variables and key pair
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)     # Looks up the AMI based on selected region from a map
  instance_type = "t2.micro"                           # Smallest free-tier eligible EC2 instance
  key_name      = aws_key_pair.levelup_key.key_name    # Associates the instance with the created key pair for SSH access

  tags = {
    Name = "custom_instance"                           # Adds a custom name tag for easy identification
  }

  # File provisioner to upload a shell script to the instance
  provisioner "file" {
    source      = "installNginx.sh"                    # Local path of the script to be uploaded
    destination = "/tmp/installNginx.sh"               # Target location on the EC2 instance
  }

  # Remote-exec provisioner to execute commands over SSH
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installNginx.sh",                 # Makes the script executable
      "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh", # Removes Windows-style carriage returns if present
      "sudo /tmp/installNginx.sh"                      # Executes the script to install Nginx
    ]
  }

  # Connection block for SSH-based access, required by the provisioners above
  connection {
    host        = coalesce(self.public_ip, self.private_ip) # Uses public IP if available, otherwise private IP
    type        = "ssh"                                      # Specifies the SSH protocol
    user        = var.INSTANCE_USERNAME                      # Username for the EC2 OS (e.g., ec2-user for Amazon Linux)
    private_key = file(var.PATH_TO_PRIVATE_KEY)              # Loads the private key for authentication
  }
}

