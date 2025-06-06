# ============================================================================================
# 📘 Purpose:
# This Terraform script creates two EC2 instances using the specified Amazon Machine Image (AMI).
# Each instance is tagged with a unique name using its count index.

# 🧠 Key Concepts:
# - aws_instance: Terraform resource to create EC2 instances on AWS
# - count: Used to provision multiple similar resources in a loop
# - AMI: Amazon Machine Image ID used to launch EC2 instances
# - tags: Metadata used to name and identify AWS resources
# ============================================================================================

resource "aws_instance" "MyFirstInstnace" {
  count         = 1                        # Create one EC2 instances using the same configuration
  ami           = "ami-0e9bbd70d26d7cf4f"  # Base image for EC2 instance (must be valid in the region)
  instance_type = "t2.micro"               #Free tier eligible and cost-effective instance type
  tags = {
    Name = "demoinstnce-${count.index}"  #Dynamically assign name like demoinstnce-0, demoinstnce-1
  }
  security_groups = var.Security_Group  # take the security groups from variables file
 
}
