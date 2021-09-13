# Create VPC
# terraform aws create vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-test-vpc"
  }
}

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "tf-test-igw"
  }
}

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public-subnet-1-cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-test-public-subnet-1"
  }
}

# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public-subnet-2-cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-test-public-subnet-2"
  }
}

# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "tf-test-public-route-table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-link" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-2-route-table-link" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}

# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnet-1-cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-test-private-subnet-1 | php-app"
  }
}

# Create Private Subnet 2
# terraform aws create subnet
resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnet-2-cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-test-private-subnet-2 | php-app"
  }
}

# Create Private Subnet 3
# terraform aws create subnet
resource "aws_subnet" "private-subnet-3" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnet-3-cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-test-private-subnet-3 | db"
  }
}

# Create Private Subnet 4
# terraform aws create subnet
resource "aws_subnet" "private-subnet-4" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnet-4-cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-test-private-subnet-4 | db"
  }
}
