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
  name = "s3-levelupbucket-role"  # Name of the IAM role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",           # EC2 will assume this role using sts:AssumeRole
      "Principal": {
        "Service": "ec2.amazonaws.com"      # This role is trusted by the EC2 service
      },
      "Effect": "Allow",                    # Allow EC2 to assume the role
      "Sid": ""                             # Optional statement ID
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
  name = "s3-levelupmybucket-role-policy"   # Name of the inline policy
  role = aws_iam_role.s3-levelupbucket-role.id  # Attach to the IAM role created above

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",                   # Allow the following actions
      "Action": [
        "s3:*"                             # Allow all S3 operations (get, put, list, etc.)
      ],
      "Resource": [
        "arn:aws:s3:::levelup-bucket-145",    # Access to the bucket itself
        "arn:aws:s3:::levelup-bucket-145/*"   # Access to all objects inside the bucket
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
  name = "s3-levelupbucket-role"         # Name of the instance profile
  role = aws_iam_role.s3-levelupbucket-role.name  # Attach the IAM role created above
}

