# ============================================================================================
# Purpose:
# This Terraform script sets up EC2 Auto Scaling with CPU-based CloudWatch alarms using Launch Templates.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# Launch Template
# Launch Templates are used to define instance configuration (modern replacement for Launch Configs).
# --------------------------------------------------------------------------------------------
resource "aws_launch_template" "levelup-launchtemplate" {
  name_prefix   = "levelup-launchtemplate"                     # Prefix for template name; AWS adds suffix.
  image_id      = lookup(var.AMIS, var.AWS_REGION)             # AMI ID chosen based on the region map.
  instance_type = "t2.micro"                                   # Free-tier eligible EC2 instance type.
  key_name      = aws_key_pair.levelup_key.key_name            # SSH key name for instance login.

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "LevelUp Custom EC2 instance"                     # Tag for instances created from this template.
    }
  }
}

# --------------------------------------------------------------------------------------------
# SSH Key Pair
# Creates a key pair from a local public key file for secure SSH access to EC2 instances.
# --------------------------------------------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                                   # Name to reference this key in AWS.
  public_key = file(var.PATH_TO_PUBLIC_KEY)                    # Path to your .pub file (e.g., ~/.ssh/id_rsa.pub).
}

# --------------------------------------------------------------------------------------------
# Auto Scaling Group
# Launches EC2 instances in multiple subnets and manages scaling based on health and CPU metrics.
# --------------------------------------------------------------------------------------------
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"             # Name of the Auto Scaling Group.
  vpc_zone_identifier       = ["subnet-9e0ad9f5", "subnet-d7a6afad"] # List of subnets to launch instances into.
  min_size                  = 1                                 # Minimum number of instances.
  max_size                  = 2                                 # Maximum number of instances.
  desired_capacity          = 1                                 # Desired number of instances at launch.
  health_check_grace_period = 200                               # Delay before health checks begin.
  health_check_type         = "EC2"                             # Use EC2 status checks for health.
  force_delete              = true                              # Ensures ASG is deleted even with running instances.

  # Use the Launch Template instead of deprecated Launch Configuration.
  launch_template {
    id      = aws_launch_template.levelup-launchtemplate.id
    version = "$Latest"                                        # Use the latest version of the launch template.
  }

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance"
    propagate_at_launch = true                                # Ensures tag is passed to launched EC2 instances.
  }
}

# --------------------------------------------------------------------------------------------
# Auto Scaling Policy - Scale Up
# This policy increases the number of instances when triggered by CloudWatch alarm.
# --------------------------------------------------------------------------------------------
resource "aws_autoscaling_policy" "levelup-cpu-policy" {
  name                   = "levelup-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1                                   # Add 1 instance when triggered.
  cooldown               = 200                                 # Wait time before allowing another scale-up event.
  policy_type            = "SimpleScaling"
}

# --------------------------------------------------------------------------------------------
# CloudWatch Alarm - High CPU
# Triggers the scale-up policy if average CPU usage is >= 30% for 4 minutes (2 periods of 2 minutes).
# --------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm" {
  alarm_name          = "levelup-cpu-alarm"
  alarm_description   = "Trigger scale-up when CPU usage is high."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2                                     # Number of periods before triggering.
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120                                   # Each period = 2 minutes.
  statistic           = "Average"
  threshold           = 30                                    # Alarm when CPU usage >= 30%.

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy.arn]  # Link alarm to scale-up policy.
}

# --------------------------------------------------------------------------------------------
# Auto Scaling Policy - Scale Down
# This policy decreases the number of instances when triggered by low CPU usage alarm.
# --------------------------------------------------------------------------------------------
resource "aws_autoscaling_policy" "levelup-cpu-policy-scaledown" {
  name                   = "levelup-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1                                  # Remove 1 instance when triggered.
  cooldown               = 200
  policy_type            = "SimpleScaling"
}

# --------------------------------------------------------------------------------------------
# CloudWatch Alarm - Low CPU
# Triggers the scale-down policy if CPU usage is <= 10% for 4 minutes (2 periods).
# --------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm-scaledown" {
  alarm_name          = "levelup-cpu-alarm-scaledown"
  alarm_description   = "Trigger scale-down when CPU usage is low."
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10                                    # Alarm when CPU usage <= 10%.

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy-scaledown.arn]
}

