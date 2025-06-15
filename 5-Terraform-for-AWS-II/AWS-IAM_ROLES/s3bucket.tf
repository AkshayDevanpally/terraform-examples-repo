# ============================================================================================
# Purpose:
# This Terraform script creates a secure AWS S3 bucket with private access and custom tagging.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# AWS S3 Bucket
# Creates a private S3 bucket for storing objects securely.
# --------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-trialpro"        # Globally unique name for the S3 bucket

  object_ownership = "ObjectWriter"         # Allows objects to be owned by the uploader; supports ACLs

  tags = {
    Name = "levelup-bucket-trialpro"        # Add a user-friendly name as a tag
  }
}

# --------------------------------------------------------------------------------------------
# S3 Bucket ACL (Access Control List)
# Set the bucket's access control to private using a dedicated ACL resource.
# --------------------------------------------------------------------------------------------
resource "aws_s3_bucket_acl" "levelup-s3bucket-acl" {
  bucket = aws_s3_bucket.levelup-s3bucket.id  # Reference the bucket created above by ID
  acl    = "private"                          # Restrict access to the bucket: only the owner has full control
}

