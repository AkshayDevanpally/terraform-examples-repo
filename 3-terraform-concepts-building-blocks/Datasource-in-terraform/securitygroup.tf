# ============================================================================================
# 📘 Purpose:
# Dynamically create a security group that allows HTTPS (port 443) inbound access 
# from the first 50 EC2 public IP ranges in the US East regions (us-east-1 and us-east-2).

# 🧠 Key Concepts:
# - Use of Terraform `data` source to fetch AWS IP ranges
# - Filtering by region and service (EC2)
# - Dynamically generate ingress rules using CIDR blocks
# - Tagging resources with metadata from the IP ranges source
# ============================================================================================

#  Data Source: Fetch public IP ranges from AWS for EC2 service in specified regions
data "aws_ip_ranges" "us_east_ip_range" {
  regions  = ["us-east-1", "us-east-2"] # Limits the IP ranges to only those from these two AWS regions

  services = ["ec2"]  # Further limits the data to IP ranges used by the EC2 service
}

#  Resource: Create a security group using dynamic IP ranges
resource "aws_security_group" "sg-custom_us_east" {
  name = "custom_us_east" # Assigns a name to the security group

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"   # Allow inbound TCP traffic on port 443 (HTTPS)

    cidr_blocks = slice(data.aws_ip_ranges.us_east_ip_range.cidr_blocks, 0, 50) # Dynamically includes the first 50 IP ranges from the fetched data
    # These are the IP ranges that will be allowed to access this resource over HTTPS
  }

  tags = {
    CreateDate = data.aws_ip_ranges.us_east_ip_range.create_date  # Metadata from AWS IP ranges (when the list was created)

    SyncToken  = data.aws_ip_ranges.us_east_ip_range.sync_token  # Used to identify the version of the IP range dataset from AWS
  }
}

