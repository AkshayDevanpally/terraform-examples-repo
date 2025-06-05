# ============================================================================================
# 📘 Purpose:
# Configure the AWS provider in Terraform to interact with AWS services in the "us-east-1" 
# region using specified credentials.

# 🧠 Key Concepts:
# - Provider configuration tells Terraform which cloud or service to use
# - Access keys are used for authenticating with AWS (use with care)
# - Semantic versioning (~> 5.45.0 means >= 5.45.0 and < 6.0.0)
# ============================================================================================

provider "aws" {
  region     = "us-east-1"          # AWS region where resources will be deployed
  version    = "~> 5.45.0"          # Use the latest patch/minor version under 6.0.0
}

