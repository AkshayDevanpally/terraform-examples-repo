# ============================================================================================
# 📘 Purpose:
# This Terraform configuration creates:
# 1. An AWS key pair to enable SSH access.
# 2. An EC2 instance in the specified availability zone using a region-specific AMI.
# 3. An additional 10 GB EBS volume.
# 4. Attaches the created EBS volume to the EC2 instance.

# 🧠 Key Concepts:
# - Dynamic AMI selection using variables
# - EBS volume creation and attachment
# - Instance resource and volume attachment binding
# ============================================================================================

# Create an AWS Key Pair for SSH access to the EC2 instance
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                        # Name of the key in AWS
  public_key = file(var.PATH_TO_PUBLIC_KEY)         # Load public key from specified path
}

# Create an AWS EC2 instance
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)  # Dynamically fetch AMI ID based on region
  instance_type     = "t2.micro"                        # Free-tier eligible instance type
  availability_zone = "us-east-1a"                      # Specify where to launch the instance
  key_name          = aws_key_pair.levelup_key.key_name # Associate the previously created key pair

  tags = {
    Name = "custom_instance"                            # Tag the instance for identification
  }
}

# Create a new EBS volume
resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "us-east-1a"              # EBS volumes must be in the same AZ as the EC2 instance
  size              = 10                        # Size of the volume in GB
  type              = "gp2"                     # General Purpose SSD type

  tags = {
    Name = "Secondary Volume Disk"              # Tag to describe the purpose of the volume
  }
}

# Attach the created EBS volume to the EC2 instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"                           # Linux device name for mounting the volume
  volume_id   = aws_ebs_volume.ebs-volume-1.id        # Reference to the created volume
  instance_id = aws_instance.MyFirstInstnace.id       # Attach to the specified EC2 instance
}

