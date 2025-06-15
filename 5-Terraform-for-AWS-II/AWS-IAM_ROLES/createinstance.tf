# ============================================================================================
# Purpose:
# This Terraform script creates a key pair, launches an EC2 instance, and associates it with
# an IAM instance profile that allows access to an S3 bucket.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# AWS Key Pair
# Create a key pair for SSH access to the EC2 instance
# --------------------------------------------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                        # AWS will register the key with this name
  public_key = file(var.PATH_TO_PUBLIC_KEY)         # Loads your SSH public key from a local file path
}

# --------------------------------------------------------------------------------------------
# EC2 Instance
# Launch an EC2 instance using the created key pair and IAM profile
# --------------------------------------------------------------------------------------------
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)          # Dynamically fetch AMI ID based on the region
  instance_type     = "t2.micro"                                # Free-tier eligible EC2 instance
  availability_zone = "us-east-1a"                              # Launch in a specific availability zone
  key_name          = aws_key_pair.levelup_key.key_name         # Use the key pair created above for SSH login

  iam_instance_profile = aws_iam_instance_profile.s3-levelupbucket-role-instanceprofile.name
  # Attach the IAM instance profile to allow access to AWS S3 bucket (via IAM role)

  tags = {
    Name = "custom_instance"                                     # Tag the instance with a friendly name
  }
}

# --------------------------------------------------------------------------------------------
# Output
# Display the public IP of the created EC2 instance after provisioning
# --------------------------------------------------------------------------------------------
output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip                # Output the public IP of the instance
}

