# My VPC
resource "aws_vpc" "Irene-vpc" {
  cidr_block       = var.cidr-for-vpc
  instance_tenancy = "default"

  tags = {
    Name = "Irene-vpc"
  }
}


# Creating networking for project
resource "aws_vpc" "DNS-setting" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Irene-vpc"
  }
}


# Public subnet 1
resource "aws_subnet" "public-subnet1" {
  vpc_id            = aws_vpc.Irene-vpc.id
  cidr_block        = var.cidr-for-pubsub1
  availability_zone = var.AZ-1

  tags = {
    Name = "public-subnet1"
  }
}

# Public subnet 2
resource "aws_subnet" "public-subnet2" {
  vpc_id            = aws_vpc.Irene-vpc.id
  cidr_block        = var.cidr-for-pubsub2
  availability_zone = var.AZ-2

  tags = {
    Name = "public-subnet2"
  }
}

# Private subnet 1
resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.Irene-vpc.id
  cidr_block        = var.cidr-for-privsub1
  availability_zone = var.AZ-3

  tags = {
    Name = "private-subnet1"
  }
}

# Private subnet 2
resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.Irene-vpc.id
  cidr_block        = var.cidr-for-privsub2
  availability_zone = var.AZ-3

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
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.IGW.id
  destination_cidr_block = "0.0.0.0/0"
}

# Create Elastic IP
resource "aws_eip" "Irene-EIP" {
  vpc = true
}

# Create NAT gateway
resource "aws_nat_gateway" "Irene-Nat-gateway" {
  allocation_id = aws_eip.Irene-EIP.id
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    Name = "Irene-Nat-gateway"
  }
}

# Associating NATgateway with private route table
resource "aws_route" "Irene-Nat-association" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.Irene-Nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}