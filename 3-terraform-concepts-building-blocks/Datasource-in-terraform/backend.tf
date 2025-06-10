# ============================================================================================
# 📘 Purpose:
# Configure Terraform to use Amazon S3 as the remote backend for storing the Terraform state file.
# This ensures team collaboration, state locking, and persistent storage across runs.

# 🧠 Key Concepts:
# - Remote backend: Allows shared and durable storage of Terraform state
# - S3 backend: Stores the `terraform.tfstate` file in a versioned S3 bucket
# - Enables collaboration by centralizing state management
# ============================================================================================

terraform {
  backend "s3" {
    bucket = "tf-state-98fty" # The name of the S3 bucket where the Terraform state will be stored.
    # Must be globally unique and pre-created in AWS.

    key    = "development/terraform_state"  # The path (key) inside the bucket to store the state file.
    # This helps organize state files by environment, e.g., development/staging/production.

    region = "us-east-1" # AWS region where the S3 bucket is located.
    # This ensures Terraform accesses the correct regional endpoint for S3.
  }
}
