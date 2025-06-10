# ============================================================================================
# ✅ Purpose:
# This Terraform configuration provisions a NAT Gateway for private subnets,
# allowing instances in private subnets to access the internet (e.g., to download updates)
# without exposing them to incoming internet traffic.

# 🧠 Key Concepts:
# - EIP (Elastic IP): Static IP address used for outbound communication
# - NAT Gateway: Forwards traffic from private subnets to the internet
# - Private Route Table: Sends traffic from private subnets through the NAT Gateway
# - Route Associations: Link private subnets to the private route table
# ============================================================================================


resource "aws_eip" "levelup-nat" {
  vpc = true                          # Allocate an Elastic IP for VPC use
}

resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id         # Attach the Elastic IP to the NAT Gateway
  subnet_id     = aws_subnet.levelupvpc-public-1.id  # NAT Gateway must be in a public subnet
  depends_on    = [aws_internet_gateway.levelup-gw]  # Ensure IGW is created before NAT
}

resource "aws_route_table" "levelup-private" {
  vpc_id = aws_vpc.levelupvpc.id

  route {
    cidr_block     = "0.0.0.0/0"                         # Route all internet-bound traffic
    nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id  # Send traffic to NAT Gateway
  }

  tags = {
    Name = "levelup-private"                            # Tag for identifying route table
  }
}

# Associate private subnets with the private route table

resource "aws_route_table_association" "level-private-1-a" {
  subnet_id      = aws_subnet.levelupvpc-private-1.id
  route_table_id = aws_route_table.levelup-private.id
}

resource "aws_route_table_association" "level-private-1-b" {
  subnet_id      = aws_subnet.levelupvpc-private-2.id
  route_table_id = aws_route_table.levelup-private.id
}

resource "aws_route_table_association" "level-private-1-c" {
  subnet_id      = aws_subnet.levelupvpc-private-3.id
  route_table_id = aws_route_table.levelup-private.id
}

