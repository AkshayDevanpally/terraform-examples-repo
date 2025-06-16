# ============================================================================================
# EC2 Instance Cluster Module
# This block uses a remote EC2 instance module to provision an EC2 instance in a specified subnet.
# ============================================================================================
module "ec2_cluster" {
  # Source of the module: pulling from a public GitHub repo for reusable EC2 provisioning
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"

  # Logical name for the instance(s); used for tagging and naming
  name = "my-cluster"

  # Amazon Machine Image (AMI) ID used to launch the instance(s)
  # Replace with the correct AMI ID for your region and OS (e.g., Amazon Linux 2)
  ami = "ami-0e9bbd70d26d7cf4f"

  # Instance type to launch
  # `t2.micro` is free-tier eligible and good for testing purposes
  instance_type = "t2.micro"

  # Subnet in which to launch the EC2 instance(s)
  # Ensure the subnet exists and belongs to the correct VPC
  subnet_id = "subnet-0ae34bdc2f72d96c3"

  # Tagging helps with identification, cost allocation, and automation
  tags = {
    Terraform   = "true"     # Indicates that this resource was provisioned by Terraform
    Environment = "dev"      # Specifies the environment (dev/stage/prod)
  }
}
