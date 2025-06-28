#############################################################
# Purpose and Overview:
# This Terraform configuration performs the following:
# - Calls reusable VPC and RDS modules to provision network infrastructure and a database
# - Creates a security group for web servers (allowing SSH, HTTP, HTTPS)
# - Defines a key pair for SSH access
# - Creates an EC2 Launch Template with Nginx pre-installed
# - Provisions an Auto Scaling Group of EC2 instances in public subnets
# - Configures an Application Load Balancer (ALB) with a listener and target group
# - Outputs the public DNS of the load balancer
#
# This setup ensures high availability and scalability of web servers with proper networking and RDS integration.
#############################################################

# Import VPC module to fetch VPC ID and subnets
module "levelup-vpc" {
  source      = "../module/vpc"
  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

# Import RDS module, using private subnets and VPC from the VPC module
module "levelup-rds" {
  source                = "../module/rds"
  ENVIRONMENT           = var.ENVIRONMENT
  AWS_REGION            = var.AWS_REGION
  vpc_private_subnet1   = module.levelup-vpc.private_subnet1_id
  vpc_private_subnet2   = module.levelup-vpc.private_subnet2_id
  vpc_id                = module.levelup-vpc.vpc_id
}

# Create a security group for web servers with SSH, HTTP, HTTPS access
resource "aws_security_group" "levelup_webservers" {
  name        = "${var.ENVIRONMENT}-levelup-webservers"
  description = "Created by Levelup"
  vpc_id      = module.levelup-vpc.vpc_id

  ingress {
    from_port   = 22      # SSH access
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.SSH_CIDR_WEB_SERVER]
  }

  ingress {
    from_port   = 80      # HTTP access
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443     # HTTPS access
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0       # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-webservers"
  }
}

# Define SSH key pair using public key file
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.public_key_path)
}

# Create EC2 launch template for web servers
resource "aws_launch_template" "webserver_template" {
  name_prefix   = "webserver-launch-template-"
  image_id      = lookup(var.AMIS, var.AWS_REGION)  # Select AMI per region
  instance_type = var.INSTANCE_TYPE
  key_name      = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [aws_security_group.levelup_webservers.id]

  # User data script to install and start Nginx
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y nginx net-tools
MYIP=$(hostname -I | awk '{print $1}')
echo "Hello Team. This is my IP: $MYIP" > /usr/share/nginx/html/index.html
systemctl enable nginx
systemctl start nginx
EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20         # 20 GB root volume
      volume_type = "gp2"
    }
  }
}

# Define Auto Scaling Group with EC2 instances
resource "aws_autoscaling_group" "levelup_webserver" {
  name                       = "levelup_WebServers"
  max_size                   = 2              # Max number of instances
  min_size                   = 1              # Minimum one instance
  desired_capacity           = 1              # Start with one
  health_check_grace_period  = 30
  health_check_type          = "EC2"
  vpc_zone_identifier        = [
    module.levelup-vpc.public_subnet1_id,
    module.levelup-vpc.public_subnet2_id
  ]  # Launch into public subnets
  target_group_arns          = [aws_lb_target_group.load_balancer_target_group.arn]

  launch_template {
    id      = aws_launch_template.webserver_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.ENVIRONMENT}-WebServer"
    propagate_at_launch = true
  }
}

# Create an Application Load Balancer
resource "aws_lb" "levelup_load_balancer" {
  name               = "${var.ENVIRONMENT}-levelup-lb"
  internal           = false                       # Public-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.levelup_webservers.id]
  subnets            = [
    module.levelup-vpc.public_subnet1_id,
    module.levelup-vpc.public_subnet2_id
  ]
}

# Create a target group for ALB
resource "aws_lb_target_group" "load_balancer_target_group" {
  name     = "load-balancer-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.levelup-vpc.vpc_id
}

# Create a listener to forward traffic from ALB to target group
resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.levelup_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target_group.arn
  }
}

# Output Load Balancer DNS to access web servers
output "load_balancer_output" {
  value = aws_lb.levelup_load_balancer.dns_name
}

