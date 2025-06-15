# ============================================================================================
# Purpose:
# This script sets up two security groups in a custom VPC:
# 1. SSH Access Group: Allows inbound SSH (port 22) from anywhere.
# 2. MariaDB Group: Allows inbound MySQL/MariaDB (port 3306) **only** from SSH-enabled instances.
#
# Prerequisite:
# - aws_vpc.levelupvpc must already exist in your configuration.
# ============================================================================================

# --------------------------------------------------------
# Security Group: allow-levelup-ssh
# Allows incoming SSH connections from anywhere
# --------------------------------------------------------
resource "aws_security_group" "allow-levelup-ssh" {
  vpc_id      = aws_vpc.levelupvpc.id                         # Attach to the specified custom VPC
  name        = "allow-levelup-ssh"                           # AWS internal SG name
  description = "Security group that allows SSH connection"  # Description for reference

  # Outbound rules: allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                                        # -1 = all protocols
    cidr_blocks = ["0.0.0.0/0"]                               # Open to all destinations
  }

  # Inbound rules: allow SSH on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                               # Open to the entire internet
  }

  tags = {
    Name = "allow-levelup-ssh"                                # Tag for easier identification
  }
}

# --------------------------------------------------------
# Security Group: allow-mariadb
# Allows incoming MariaDB/MySQL connections (port 3306) **only** from instances
# that are part of the allow-levelup-ssh security group
# --------------------------------------------------------
resource "aws_security_group" "allow-mariadb" {
  vpc_id      = aws_vpc.levelupvpc.id                         # Attach to the same custom VPC
  name        = "allow-mariadb"                               # AWS internal SG name
  description = "Security group for MariaDB"                  # Clear description

  # Outbound rules: allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rules: allow MySQL/MariaDB (port 3306) only from the SSH SG
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.allow-levelup-ssh.id]  # Restrict to internal SG access
  }

  tags = {
    Name = "allow-mariadb"
  }
}

