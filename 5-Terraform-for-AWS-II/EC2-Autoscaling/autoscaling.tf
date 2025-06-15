# ============================================================================================
# Purpose:
# This Terraform script sets up EC2 Auto Scaling with CPU-based CloudWatch alarms for scale-in and scale-out.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# Launch Configuration
# Specifies the AMI, instance type, and key pair for launching EC2 instances in the ASG
# --------------------------------------------------------------------------------------------
resource "aws_launch_configuration" "levelup-launchconfig" {
  name_prefix     = "levelup-launchconfig"                                # Prefix for launch config name
  image_id        = lookup(var.AMIS, var.AWS_REGION)                      # Dynamically pick AMI based on region
  instance_type   = "t2.micro"                                            # Free-tier eligible instance type
  key_name        = aws_key_pair.levelup_key.key_name                    # Associate SSH key for instance access
}

# --------------------------------------------------------------------------------------------
# SSH Key Pair
# Creates an AWS key pair using a local public key file for SSH access to EC2 instances
# --------------------------------------------------------------------------------------------
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"                                              # Key name used in EC2 launch
  public_key = file(var.PATH_TO_PUBLIC_KEY)                              # Path to your local .pub file
}

# --------------------------------------------------------------------------------------------
# Auto Scaling Group
# Defines an ASG across two subnets with 1-2 instances and EC2 health checks
# --------------------------------------------------------------------------------------------
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"                       # ASG name
  vpc_zone_identifier       = ["subnet-9e0ad9f5", "subnet-d7a6afad"]      # List of subnet IDs
  launch_configuration      = aws_launch_configuration.levelup-launchconfig.name  # Attach launch config
  min_size                  = 1                                           # Minimum instance count
  max_size                  = 2                                           # Maximum instance count
  health_check_grace_period = 200                                         # Wait time before checking health
  health_check_type         = "EC2"                                       # Use EC2 status checks
  force_delete              = true                                        # Force delete ASG on destroy

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance"                   # Tag EC2 instances
    propagate_at_launch = true                                           # Ensure tag gets applied to new instances
  }
}

# --------------------------------------------------------------------------------------------
# Auto Scaling Policy - Scale Up
# Increase instance count when CPU usage is high
# --------------------------------------------------------------------------------------------
resource "aws_autoscaling_policy" "levelup-cpu-policy" {
  name                   = "levelup-cpu-policy"                           # Policy name
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
  adjustment_type        = "ChangeInCapacity"                            # Change instance count
  scaling_adjustment     = "1"                                            # Add 1 instance
  cooldown               = "200"                                          # Wait time before next scaling
  policy_type            = "SimpleScaling"                               
}

# --------------------------------------------------------------------------------------------
# CloudWatch Alarm - CPU Usage High (Scale Up Trigger)
# Triggers the scaling policy if CPU is >= 30% for 4 minutes (2x 2-minute periods)
# --------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm" {
  alarm_name          = "levelup-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"                                               # Two consecutive periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"                                             # Each period = 2 minutes
  statistic           = "Average"
  threshold           = "30"                                              # CPU threshold

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy.arn]      # Link to scale-up policy
}

# --------------------------------------------------------------------------------------------
# Auto Scaling Policy - Scale Down
# Decrease instance count when CPU usage is low
# --------------------------------------------------------------------------------------------
resource "aws_autoscaling_policy" "levelup-cpu-policy-scaledown" {
  name                   = "levelup-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"                                           # Remove 1 instance
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

# --------------------------------------------------------------------------------------------
# CloudWatch Alarm - CPU Usage Low (Scale Down Trigger)
# Triggers the downscale policy if CPU is <= 10% for 4 minutes
# --------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm-scaledown" {
  alarm_name          = "levelup-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"                                              # Scale down below 10%

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy-scaledown.arn]  # Link to scale-down policy
}

