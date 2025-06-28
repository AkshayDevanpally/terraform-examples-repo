#############################################################
# Purpose and Overview:
# This Terraform configuration:
# - Calls a custom VPC module to retrieve VPC and subnet details
# - Creates an RDS Subnet Group using private subnets from the VPC
# - Creates a Security Group that allows MySQL traffic on port 3306
# - Provisions an RDS instance (e.g., MySQL/PostgreSQL) using the above setup
# - Outputs the RDS endpoint for application access
#
# This setup ensures secure RDS deployment within a private network.
#############################################################

# Call VPC Module to fetch subnet IDs and VPC ID
module "levelup-vpc" {
  source      = "../vpc"              # Path to the VPC module
  ENVIRONMENT = var.ENVIRONMENT       # Environment (e.g., dev, prod)
  AWS_REGION  = var.AWS_REGION        # AWS Region for deployment
}

# Define Subnet Group for RDS Service using two private subnets
resource "aws_db_subnet_group" "levelup-rds-subnet-group" {
  name        = "${var.ENVIRONMENT}-levelup-db-snet"    # Unique name for subnet group
  description = "Allowed subnets for DB cluster instances"

  subnet_ids = [
    module.levelup-vpc.private_subnet1_id,  # Private Subnet 1 from VPC module
    module.levelup-vpc.private_subnet2_id   # Private Subnet 2 from VPC module
  ]

  tags = {
    Name = "${var.ENVIRONMENT}_levelup_db_subnet"
  }
}

# Define Security Group to control access to RDS
resource "aws_security_group" "levelup-rds-sg" {
  name        = "${var.ENVIRONMENT}-levelup-rds-sg"
  description = "Created by LevelUp"
  vpc_id      = module.levelup-vpc.vpc_id  # VPC ID from VPC module

  ingress {
    from_port   = 3306                 # MySQL port
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.RDS_CIDR]       # Allowed CIDR (e.g., app server range)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                 # All protocols
    cidr_blocks = ["0.0.0.0/0"]        # Allow all outbound traffic
  }

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-rds-sg"
  }
}

# Provision the RDS instance
resource "aws_db_instance" "levelup-rds" {
  identifier                = "${var.ENVIRONMENT}-levelup-rds"  # DB identifier
  allocated_storage         = var.LEVELUP_RDS_ALLOCATED_STORAGE # Storage in GB
  storage_type              = "gp2"                              # General Purpose SSD
  engine                    = var.LEVELUP_RDS_ENGINE             # DB Engine (e.g., mysql, postgres)
  engine_version            = var.LEVELUP_RDS_ENGINE_VERSION     # Engine version
  instance_class            = var.DB_INSTANCE_CLASS              # e.g., db.t2.micro
  backup_retention_period   = var.BACKUP_RETENTION_PERIOD        # Backup retention in days
  publicly_accessible       = var.PUBLICLY_ACCESSIBLE            # False to keep DB private
  username                  = var.LEVELUP_RDS_USERNAME           # Master username
  password                  = var.LEVELUP_RDS_PASSWORD           # Master password
  vpc_security_group_ids    = [aws_security_group.levelup-rds-sg.id] # Attach SG created above
  db_subnet_group_name      = aws_db_subnet_group.levelup-rds-subnet-group.name # Attach DB subnet group
  multi_az                  = false                              # Single AZ deployment
}

# Output RDS Endpoint to use in applications
output "rds_prod_endpoint" {
  value = aws_db_instance.levelup-rds.endpoint
}

