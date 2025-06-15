# ============================================================================================
# Purpose:
# This Terraform script creates an IAM role for EC2 to access a specific S3 bucket,
# attaches a policy to allow S3 operations, and defines an instance profile for EC2.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# IAM Role
# Create a role that EC2 instances can assume to access S3
# --------------------------------------------------------------------------------------------
resource "aws_iam_role" "s3-levelupbucket-role" {
  name = "s3-levelupbucket-role"

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
# Attach inline policy to the above role to allow full access to a specific S3 bucket
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
        "arn:aws:s3:::levelup-bucket-trialpro",
        "arn:aws:s3:::levelup-bucket-trialpro/*"
      ]
    }
  ]
}
EOF
}

# --------------------------------------------------------------------------------------------
# IAM Instance Profile
# Create an instance profile to associate the IAM role with an EC2 instance
# --------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "s3-levelupbucket-role-instanceprofile" {
  name = "s3-levelupbucket-role"
  role = aws_iam_role.s3-levelupbucket-role.name
}

