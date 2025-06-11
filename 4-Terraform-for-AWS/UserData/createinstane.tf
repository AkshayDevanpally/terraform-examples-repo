# ============================================================================================
# Purpose:
# This configuration performs the following:
# 1. Creates an AWS key pair to allow SSH access.
# 2. Launches an EC2 instance using a specified AMI.
# 3. Installs Apache automatically at boot using a shell script.
# 4. Outputs the public IP address of the instance after creation.

# Key Concepts:
# - Key pairs for secure login
# - EC2 instance deployment using region-based AMI
# - Bootstrapping with user data
# - Output values for access and debugging
# ============================================================================================

# Key pair resource to enable SSH access
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                      # Name of the key pair in AWS
  public_key = file(var.PATH_TO_PUBLIC_KEY)       # Load the public SSH key from file
}

# EC2 instance creation
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)    # Select AMI dynamically based on the region
  instance_type     = "t2.micro"                          # Use a micro instance (free tier)
  availability_zone = "us-east-1a"                        # Launch the instance in this availability zone
  key_name          = aws_key_pair.levelup_key.key_name   # Use the created key pair for access

  user_data         = file("installapache.sh")            # Shell script to install Apache at instance boot

  tags = {
    Name = "custom_instance"                              # Tag the instance for identification
  }
}

# Output the public IP of the instance
output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip          # Display the instance's public IP
}


