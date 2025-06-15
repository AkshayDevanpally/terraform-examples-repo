# ============================================================================================
# Purpose:
# This Terraform script provisions a secure and customized Amazon RDS MariaDB instance:
# - Configures private subnets for RDS (via DB Subnet Group)
# - Sets custom MariaDB parameters
# - Creates an actual RDS instance with backups and tagging
# ============================================================================================

# --------------------------------------------------------------------------------------------
# RDS Subnet Group
# Ensures the RDS instance launches in **private subnets** (for security)
# --------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "mariadb-subnets" {
  name        = "mariadb-subnets"
  description = "Amazon RDS subnet group for private subnets"
  subnet_ids  = [
    aws_subnet.levelupvpc-private-1.id,
    aws_subnet.levelupvpc-private-2.id
  ]
}

# --------------------------------------------------------------------------------------------
# RDS Parameter Group
# Customizes DB behavior by setting configuration parameters
# --------------------------------------------------------------------------------------------
resource "aws_db_parameter_group" "levelup-mariadb-parameters" {
  name        = "levelup-mariadb-parameters"
  family      = "mariadb10.11"
  description = "MariaDB custom parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"  # In bytes; increases the allowed packet size
  }
}

# --------------------------------------------------------------------------------------------
# RDS Instance
# Deploys a MariaDB instance into private subnets with custom settings
# --------------------------------------------------------------------------------------------
resource "aws_db_instance" "levelup-mariadb" {
  allocated_storage        = 20                                # GB of storage
  engine                   = "mariadb"
  engine_version           = "10.11.13"
  instance_class           = "db.t2.micro"                     # Free-tier eligible
  identifier               = "mariadb"                         # Unique DB ID
  db_name                     = "mariadb"                         # Default DB name
  username                 = "root"                            # Master username
  password                 = "mariadb141"                      # Master password (consider using secrets!)
  db_subnet_group_name     = aws_db_subnet_group.mariadb-subnets.name
  parameter_group_name     = aws_db_parameter_group.levelup-mariadb-parameters.name
  multi_az                 = false                             # Single AZ deployment
  vpc_security_group_ids   = [aws_security_group.allow-mariadb.id]  # DB security
  storage_type             = "gp2"
  backup_retention_period  = 30                                # Retain backups for 30 days
  availability_zone        = aws_subnet.levelupvpc-private-1.availability_zone
  skip_final_snapshot      = true                              # Don't require snapshot on destroy

  tags = {
    Name = "levelup-mariadb"
  }
}

# --------------------------------------------------------------------------------------------
# Output: RDS Endpoint
# Helpful for connecting to the DB post-provision
# --------------------------------------------------------------------------------------------
output "rds" {
  value = aws_db_instance.levelup-mariadb.endpoint
}

