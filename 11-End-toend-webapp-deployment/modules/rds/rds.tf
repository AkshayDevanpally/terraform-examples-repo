
#############################################################
# Purpose and Overview:
# This Terraform configuration provisions the following:
# - A DB Subnet Group for RDS to place the database in two private subnets
# - A Security Group allowing MySQL traffic on port 3306
# - An AWS RDS instance using the above subnet group and security group
#
#
#############################################################

# Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "levelup-rds-subnet-group" {
  name        = "${var.ENVIRONMENT}-levelup-db-snet"  # Unique name for the subnet group
  description = "Allowed subnets for DB cluster instances"

  subnet_ids = [
    var.vpc_private_subnet1,  # First private subnet ID
    var.vpc_private_subnet2   # Second private subnet ID
  ]

  tags = {
    Name = "${var.ENVIRONMENT}_levelup_db_subnet"  # Tag to identify the subnet group
  }
}

# Define Security Group for RDS to allow database access
resource "aws_security_group" "levelup-rds-sg" {
  name        = "${var.ENVIRONMENT}-levelup-rds-sg"   # Name of the security group
  description = "Created by LevelUp"
  vpc_id      = var.vpc_id                            # VPC ID where this SG will reside

  ingress {
    from_port   = 3306               # Start of MySQL port range
    to_port     = 3306               # End of MySQL port range
    protocol    = "tcp"              # TCP protocol for database access
    cidr_blocks = [var.RDS_CIDR]     # CIDR block allowed to connect (e.g., app server IP range)
  }

  egress {
    from_port   = 0                  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ENVIRONMENT}-levelup-rds-sg"
  }
}

# Provision the RDS Instance
resource "aws_db_instance" "levelup-rds" {
  identifier                = "${var.ENVIRONMENT}-levelup-rds"  # Unique DB identifier
  allocated_storage         = var.LEVELUP_RDS_ALLOCATED_STORAGE # Disk space for DB
  storage_type              = "gp2"                              # General purpose SSD
  engine                    = var.LEVELUP_RDS_ENGINE             # e.g., mysql, postgres
  engine_version            = var.LEVELUP_RDS_ENGINE_VERSION     # Specific DB engine version
  instance_class            = var.DB_INSTANCE_CLASS              # e.g., db.t2.micro
  backup_retention_period   = var.BACKUP_RETENTION_PERIOD        # Number of days to keep backups
  publicly_accessible       = var.PUBLICLY_ACCESSIBLE            # Whether DB is accessible from the internet
  username                  = var.LEVELUP_RDS_USERNAME           # Master DB username
  password                  = var.LEVELUP_RDS_PASSWORD           # Master DB password
  vpc_security_group_ids    = [aws_security_group.levelup-rds-sg.id]  # SG for database access
  db_subnet_group_name      = aws_db_subnet_group.levelup-rds-subnet-group.name  # Subnet group for network placement
  multi_az                  = "false"                            # Disable multi-AZ deployment
}

# Output the endpoint of the RDS instance
output "rds_prod_endpoint" {
  value = aws_db_instance.levelup-rds.endpoint  # Returns the DB endpoint URL
}

