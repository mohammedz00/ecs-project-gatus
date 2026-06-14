# VPC

resource "aws_vpc" "gatus-vpc" {

  cidr_block           = var.local_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }

}

# Subnets
resource "aws_subnet" "public_subnet_a" {

  vpc_id                  = aws_vpc.gatus-vpc.id
  cidr_block              = var.public_subnet_cidr[0]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]

  tags = {
    Name = "PublicSubnetA"
  }

}

resource "aws_subnet" "private_subnet_a" {

  vpc_id            = aws_vpc.gatus-vpc.id
  cidr_block        = var.private_subnet_cidr[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "PrivateSubnetA"
  }

}

resource "aws_subnet" "public_subnet_b" {

  vpc_id                  = aws_vpc.gatus-vpc.id
  cidr_block              = var.public_subnet_cidr[1]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[1]

  tags = {
    Name = "PublicSubnetB"
  }

}

resource "aws_subnet" "private_subnet_b" {

  vpc_id            = aws_vpc.gatus-vpc.id
  cidr_block        = var.private_subnet_cidr[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "PrivateSubnetB"
  }

}

# Internet Gateway
resource "aws_internet_gateway" "gatus-igw" {
  vpc_id = aws_vpc.gatus-vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }

}

# Elastic IP allocation
resource "aws_eip" "natgw-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gatus-igw]
}

# NAT Gateway
resource "aws_nat_gateway" "gatus-natgw" {
  connectivity_type = "public"
  allocation_id     = aws_eip.natgw-eip.id
  subnet_id         = aws_subnet.public_subnet_a.id
  depends_on        = [aws_internet_gateway.gatus-igw]

  tags = {
    Name = "${var.project_name}-natgw"
  }
}


# Route tables

# Public Route
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.gatus-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gatus-igw.id
  }

  tags = {
    Name = "PublicRoute"
  }

}

# Private Route
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.gatus-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gatus-natgw.id
  }

  tags = {
    Name = "PrivateRoute"
  }

}

# Route table associations

# Public route associations
resource "aws_route_table_association" "public-route-association-a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public-route-association-b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route.id
}

# Private route associations
resource "aws_route_table_association" "private-route-association-a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private-route-association-b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route.id
}