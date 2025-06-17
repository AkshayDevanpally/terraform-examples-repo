# ============================================================================================
# 📤 Terraform Outputs for "LevelUp" VPC Infrastructure
# These values are printed after successful Terraform apply and can be used by other modules.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# 🆔 VPC ID Output
# Outputs the ID of the VPC for use in cross-module references or remote states
# --------------------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.levelup_vpc.id
}

# --------------------------------------------------------------------------------------------
# 📦 Public Subnet ID Output
# Outputs the ID of the public subnet for use in other modules like EC2, ALB, etc.
# --------------------------------------------------------------------------------------------
output "public_subnet_id" {
  description = "The ID of the public subnet created within the VPC"
  value       = aws_subnet.subnet_public.id
}

# --------------------------------------------------------------------------------------------
# 🔐 Security Group ID Output
# Outputs the ID of the SSH (port 22) security group as a list (useful in modules expecting list format)
# --------------------------------------------------------------------------------------------
output "sg_22_id" {
  description = "List containing the ID of the security group allowing SSH (port 22) access"
  value       = [aws_security_group.levelup_sg_22.id]
}

