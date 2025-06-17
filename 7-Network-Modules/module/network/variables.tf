# ============================================================================================
# 🛠️ Terraform Input Variables
# These variables are used to parameterize the VPC infrastructure components
# ============================================================================================

# --------------------------------------------------------------------------------------------
# 🧱 VPC CIDR Block
# Defines the IP range for the entire Virtual Private Cloud (VPC)
# --------------------------------------------------------------------------------------------
variable "cidr_vpc" {
  description = "CIDR block for the VPC (e.g., 10.1.0.0/16 allows up to 65K IPs)"
  default     = "10.1.0.0/16"
}

# --------------------------------------------------------------------------------------------
# 📦 Subnet CIDR Block
# Subset of the VPC CIDR range used to deploy resources like EC2, ALB, etc.
# --------------------------------------------------------------------------------------------
variable "cidr_subnet" {
  description = "CIDR block for the subnet within the VPC"
  default     = "10.1.0.0/24" # Provides 256 IP addresses
}

# --------------------------------------------------------------------------------------------
# 🌍 Availability Zone
# Defines the AZ where the subnet will be launched (must match your region)
# --------------------------------------------------------------------------------------------
variable "availability_zone" {
  description = "Availability zone to create the subnet in"
  default     = "us-east-1a"
}

# --------------------------------------------------------------------------------------------
# 🔐 Public SSH Key
# Path to your SSH public key file used for EC2 key pair provisioning
# --------------------------------------------------------------------------------------------
variable "public_key_path" {
  description = "Path to the public SSH key (used to access EC2 instances)"
  default     = "~/.ssh/levelup_key.pub"
}

# --------------------------------------------------------------------------------------------
# 🏷️ Environment Tag
# Label used to categorize resources (e.g., Dev, QA, Prod)
# --------------------------------------------------------------------------------------------
variable "environment_tag" {
  description = "Environment tag to be applied to resources"
  default     = "Production"
}

