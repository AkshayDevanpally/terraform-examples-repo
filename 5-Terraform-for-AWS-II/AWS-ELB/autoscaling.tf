# ============================================================================================
# Launch Template Configuration
# This resource defines a reusable template to launch EC2 instances.
# ============================================================================================
resource "aws_launch_template" "levelup-launchtemplate" {
  name_prefix   = "levelup-launchtemplate"                     # AWS will append a unique suffix.
  image_id      = lookup(var.AMIS, var.AWS_REGION)             # Fetch AMI ID based on region using variable map.
  instance_type = "t2.micro"                                   # EC2 instance type (eligible under AWS free tier).
  key_name      = aws_key_pair.levelup_key.key_name            # Key pair used for SSH access to instances.

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y net-tools nginx
systemctl enable nginx
systemctl start nginx
MYIP=$(hostname -I | awk '{print $1}')
echo -e "Hello Team\nThis is my IP: \$MYIP" > /usr/share/nginx/html/index.html
EOF
  )

  # Attach the custom security group to the instance
  vpc_security_group_ids = [
    aws_security_group.levelup-instance.id
  ]

  lifecycle {
    create_before_destroy = true                                # Ensures zero downtime by creating before destroying.
  }

  # Add Name tag to EC2 instances launched from this template
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "LevelUp Custom EC2 instance"                     # Helpful for identifying resources in AWS Console.
    }
  }
}

# ============================================================================================
# SSH Key Pair Resource
# Creates a reusable SSH key in AWS from a local public key file.
# ============================================================================================
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                                   # Key pair name used for EC2 SSH login.
  public_key = file(var.PATH_TO_PUBLIC_KEY)                    # Load public key from provided file path.
}

# ============================================================================================
# Auto Scaling Group
# Automatically scales instances based on load and health status.
# ============================================================================================
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name = "levelup-autoscaling"                                 # Name of the Auto Scaling Group.

  vpc_zone_identifier = [                                      # Deploy instances in two public subnets (multi-AZ).
    aws_subnet.levelupvpc-public-1.id,
    aws_subnet.levelupvpc-public-2.id
  ]

  min_size                  = 2                                 # Maintain at least 2 instances.
  max_size                  = 2                                 # Allow maximum of 2 instances.
  desired_capacity          = 2                                 # Launch 2 instances initially to match min/max.
  health_check_grace_period = 200                               # Wait time before health checks begin.
  health_check_type         = "ELB"                             # Use ELB health checks (vs EC2 status checks).
  load_balancers            = [aws_elb.levelup-elb.name]        # Attach to Elastic Load Balancer.
  force_delete              = true                              # Automatically delete ASG even if instances are running.

  # Attach the launch template created above
  launch_template {
    id      = aws_launch_template.levelup-launchtemplate.id     # Reference to the launch template.
    version = "$Latest"                                         # Always use the most recent version.
  }

  # Apply Name tag to all launched EC2 instances
  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance"
    propagate_at_launch = true                                  # Propagate this tag to the EC2 instances.
  }
}

# ============================================================================================
# Output Section
# After apply, display the ELB DNS name in the terminal.
# ============================================================================================
output "ELB" {
  value = aws_elb.levelup-elb.dns_name                         # Useful for testing in browser.
}

