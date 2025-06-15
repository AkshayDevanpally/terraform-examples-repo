# ============================================================================================
# Purpose:
# This Terraform script creates a secure AWS S3 bucket with private access and custom tagging.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# AWS S3 Bucket
# Creates a private S3 bucket for storing objects securely.
# --------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-145"   # Unique bucket name globally
  acl    = "private"              # Access control set to private (owner only)

  tags = {
    Name = "levelup-bucket-141"   # Tag the bucket with a friendly name
  }
}

