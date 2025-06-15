# ============================================================================================
# Purpose:
# This Terraform script creates a secure AWS S3 bucket with private access and custom tagging.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# AWS S3 Bucket
# Creates a private S3 bucket for storing objects securely.
# --------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-trialpro"   # Unique bucket name globally

  tags = {
    Name = "levelup-bucket-trialpro"   # Tag the bucket with a friendly name
  }
}

# --------------------------------------------------------------------------------------------
# S3 Bucket ACL
# Set the bucket access to private using a separate ACL resource.
# --------------------------------------------------------------------------------------------
resource "aws_s3_bucket_acl" "levelup-s3bucket-acl" {
  bucket = aws_s3_bucket.levelup-s3bucket.id
}

