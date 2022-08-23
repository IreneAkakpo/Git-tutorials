# My VPC
resource "aws_vpc" "Irene-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Irene-vpc"
  }
}

# Public subnet
resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.Irene-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet1"
  }
}

# Public subnet
resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.Irene-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public-subnet2"
  }
}

# Private subnet
resource "aws_subnet" "private-subnet1" {
  vpc_id     = aws_vpc.Irene-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private-subnet1"
  }
}

# Private subnet
resource "aws_subnet" "private-subnet2" {
  vpc_id     = aws_vpc.Irene-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private-subnet2"
  }
}

# Public route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.Irene-vpc.id

  tags = {
    Name = "public-route-table"
  }
}

# Private route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.Irene-vpc.id

  tags = {
    Name = "private-route-table"
  }
}

# Route table association pub1
resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-route-table.id
}

# Route table association pub2
resource "aws_route_table_association" "public-route-table-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-route-table.id
}

# Route table association priv1
resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-route-table.id
}

# Route table association priv2
resource "aws_route_table_association" "private-route-table-association2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-route-table.id
}

# MY internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Irene-vpc.id

  tags = {
    Name = "IGW"
  }
}

# AWS Route IGW-Public routable
resource "aws_route" "public-igw-route" {
  route_table_id            = aws_route_table.public-route-table.id
  gateway_id = aws_internet_gateway.IGW.id
  destination_cidr_block    = "0.0.0.0/0"
}

# Create Elastic IP
resource "aws_eip" "Irene-EIP" {
  vpc = true
}

# Create NAT gateway
resource "aws_nat_gateway" "Irene-Nat-gateway" {
  allocation_id = aws_eip.Irene-EIP.id
  subnet_id = aws_subnet.public-subnet1.id

  tags = {
    Name = "Irene-Nat-gateway"
  }
}

# Associating NATgateway with private route table
resource "aws_route" "Irene-Nat-association" {
  route_table_id = aws_route_table.private-route-table
  nat_gateway_id = aws_nat_gateway.Irene-Nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}