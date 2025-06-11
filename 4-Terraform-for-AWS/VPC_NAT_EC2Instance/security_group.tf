# ============================================================================================
# ✅ Purpose:
# Create a security group within a custom VPC to allow secure SSH access to EC2 instances.
# The security group allows inbound SSH traffic from any IP and all outbound traffic.

# 🧠 Key Concepts:
# - Security Group: Acts as a virtual firewall for controlling inbound and outbound traffic
# - Ingress Rule: Controls incoming traffic (e.g., allow SSH)
# - Egress Rule: Controls outgoing traffic (e.g., allow all outbound connections)
# - Tagging: Helps identify and organize AWS resources
# ============================================================================================

resource "aws_security_group" "allow-levelup-ssh" {
  vpc_id      = aws_vpc.levelupvpc.id               # Attach the security group to the specified VPC
  name        = "allow-levelup-ssh"                 # Name of the security group
  description = "security group that allows ssh connection"  # Descriptive text for documentation

  egress {
    from_port   = 0                                 # Start of port range (0 = all ports)
    to_port     = 0                                 # End of port range (0 = all ports)
    protocol    = "-1"                              # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]                     # Allow outbound traffic to any IP
  }

  ingress {
    from_port   = 22                                # Start port for SSH
    to_port     = 22                                # End port for SSH (just port 22)
    protocol    = "tcp"                             # TCP protocol (SSH runs on TCP)
    cidr_blocks = ["0.0.0.0/0"]                     # Allow SSH access from anywhere 
  }

  tags = {
    Name = "allow-levelup-ssh"                      # Name tag for easy identification in the AWS console
  }
}

