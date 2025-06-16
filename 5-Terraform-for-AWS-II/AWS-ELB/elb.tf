# ============================================================================================
# Purpose:
# This Terraform script sets up an AWS Classic Elastic Load Balancer (ELB) with proper
# health checks, cross-zone load balancing, and security groups for both the ELB and instances.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# Create AWS Classic Load Balancer (ELB)
# --------------------------------------------------------------------------------------------
resource "aws_elb" "levelup-elb" {
  name            = "levelup-elb"                                                  # Name of the ELB

  subnets         = [                                                              # Attach ELB to public subnets
    aws_subnet.levelupvpc-public-1.id,
    aws_subnet.levelupvpc-public-2.id
  ]

  security_groups = [                                                              # Associate ELB security group
    aws_security_group.levelup-elb-securitygroup.id
  ]
  
  listener {                                                                        # ELB listener configuration
    instance_port     = 80                                                          # Forward traffic to instance port 80
    instance_protocol = "http"                                                      # Protocol between ELB and instances
    lb_port           = 80                                                          # ELB listens on port 80
    lb_protocol       = "http"                                                      # Protocol for ELB clients
  }

  health_check {                                                                    # Health check config for instances
    healthy_threshold   = 2                                                         # 2 successful checks = healthy
    unhealthy_threshold = 2                                                         # 2 failed checks = unhealthy
    timeout             = 3                                                         # Timeout for each health check
    target              = "HTTP:80/"                                                # URL path for health check
    interval            = 30                                                        # Time between checks (in seconds)
  }

  cross_zone_load_balancing   = true                                                # Distribute traffic across AZs
  connection_draining         = true                                                # Keep connections alive during deregistration
  connection_draining_timeout = 400                                                 # Wait time before closing connections

  tags = {
    Name = "levelup-elb"                                                            # Tagging the ELB for identification
  }
}

# --------------------------------------------------------------------------------------------
# Security Group for the Load Balancer (ELB)
# --------------------------------------------------------------------------------------------
resource "aws_security_group" "levelup-elb-securitygroup" {
  vpc_id      = aws_vpc.levelupvpc.id                                               # VPC where this SG is created
  name        = "levelup-elb-sg"                                                    # Name of the security group
  description = "security group for Elastic Load Balancer"

  egress {
    from_port   = 0                                                                  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80                                                                 # Allow inbound HTTP traffic
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                                                      # From anywhere (public access)
  }

  tags = {
    Name = "levelup-elb-sg"                                                          # Tag for identification
  }
}

# --------------------------------------------------------------------------------------------
# Security Group for EC2 Instances
# Allows SSH from the internet and HTTP from the ELB
# --------------------------------------------------------------------------------------------
resource "aws_security_group" "levelup-instance" {
  vpc_id      = aws_vpc.levelupvpc.id                                               # VPC for instance security group
  name        = "levelup-instance"
  description = "security group for instances"

  egress {
    from_port   = 0                                                                  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22                                                                 # Allow SSH access
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                                                      # From anywhere (be cautious in production)
  }

  ingress {
    from_port       = 80                                                             # Allow HTTP traffic
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.levelup-elb-securitygroup.id]             # Only allow traffic from ELB SG
  }

  tags = {
    Name = "levelup-instance"                                                       # Tag for easy identification
  }
}

