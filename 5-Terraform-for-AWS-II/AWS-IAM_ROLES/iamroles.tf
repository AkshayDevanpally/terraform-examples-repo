# ============================================================================================
# Purpose:
# This Terraform script creates an IAM role, attaches a policy to allow access to a specific
# S3 bucket, and sets up an instance profile to assign the role to an EC2 instance.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# IAM Role for EC2 Access to S3
# Define a trust policy that allows EC2 instances to assume this IAM role
# --------------------------------------------------------------------------------------------
resource "aws_iam_role" "s3-levelupbucket-role" {
  name               = "s3-levelupbucket-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# --------------------------------------------------------------------------------------------
# IAM Role Policy
# Attach an inline policy to the above IAM role granting full access to a specific S3 bucket
# --------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "s3-levelupmybucket-role-policy" {
  name = "s3-levelupmybucket-role-policy"
  role = aws_iam_role.s3-levelupbucket-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::levelup-bucket-145",
        "arn:aws:s3:::levelup-bucket-145/*"
      ]
    }
  ]
}
EOF
}

# --------------------------------------------------------------------------------------------
# IAM Instance Profile
# Create an instance profile to associate the IAM role with EC2 instances
# --------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "s3-levelupbucket-role-instanceprofile" {
  name = "s3-levelupbucket-role"
  role = aws_iam_role.s3-levelupbucket-role.name
}

