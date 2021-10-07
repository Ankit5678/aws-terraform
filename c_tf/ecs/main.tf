# # create VPC
# # 
# # create custom route table
# # create public subnet for lb Subnets
# # associate subnet with route table
# # create security group
# # create nats gateway for public to private subnet conection
# # create a private ecr

# # VPC
# resource "aws_vpc" "c_vpc" {
#   cidr_block           = var.c_vpc_cidr
#   instance_tenancy     = "default"
#   enable_dns_hostnames = true

#   tags = {
#     Name = "tf-test-vpc"
#   }
# }

# # Internet Gateway
# resource "aws_internet_gateway" "c_internet_gateway" {
#   vpc_id = aws_vpc.c_vpc.id

#   tags = {
#     Name = "tf-test-igw"
#   }
# }

# # Public Subnets
# resource "aws_subnet" "c_public_subnet_az_a" {
#   vpc_id                  = aws_vpc.c_vpc.id
#   cidr_block              = var.c_public_subnet_az_a_cidr
#   availability_zone       = var.az_a
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "tf-test-public-subnet-a"
#   }
# }

# resource "aws_subnet" "c_public_subnet_az_b" {
#   vpc_id                  = aws_vpc.c_vpc.id
#   cidr_block              = var.c_public_subnet_az_b_cidr
#   availability_zone       = var.az_b
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "tf-test-public-subnet-b"
#   }
# }

# resource "aws_subnet" "c_public_subnet_az_c" {
#   vpc_id                  = aws_vpc.c_vpc.id
#   cidr_block              = var.c_public_subnet_az_c_cidr
#   availability_zone       = var.az_c
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "tf-test-public-subnet-c"
#   }
# }

# # Private Subnets
# resource "aws_subnet" "c_private_subnet_az_a" {
#   vpc_id                  = aws_vpc.c_vpc.id
#   cidr_block              = var.c_private_subnet_az_a_cidr
#   availability_zone       = var.az_a
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "tf-test-private-subnet-a"
#   }
# }

# resource "aws_subnet" "c_private_subnet_az_b" {
#   vpc_id                  = aws_vpc.c_vpc.id
#   cidr_block              = var.c_private_subnet_az_b_cidr
#   availability_zone       = var.az_b
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "tf-test-private-subnet-b"
#   }
# }

# resource "aws_subnet" "c_private_subnet_az_c" {
#   vpc_id                  = aws_vpc.c_vpc.id
#   cidr_block              = var.c_private_subnet_az_c_cidr
#   availability_zone       = var.az_c
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "tf-test-private-subnet-c"
#   }
# }

# # Create security groups
# # Create Security Group for the Application Load Balancer
# resource "aws_security_group" "c_app_lb_security_group" {
#   name        = "APP LB Security Group"
#   description = "Enable HTTP and HTTPs on port 80 and 443"
#   vpc_id      = aws_vpc.c_vpc.id

#   ingress {
#     description = "HTTP access port 80"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTPs access on port 443"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "tf-test-app-lb-security-group"
#   }
# }

# # # Create Security Group for the Bastion Host aka Jump Box
# # resource "aws_security_group" "ssh-security-group" {
# #   name = "ssh access security group"
# #   description = "Enable ssh access on port 22"
# #   vpc_id = aws_vpc.vpc.id

# #   ingress {
# #     description = "ssh access on port 22"
# #     from_port = 22
# #     to_port = 22
# #     protocol = "tcp"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   egress {
# #     from_port = 0
# #     to_port = 0
# #     protocol = "-1"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   tags = {
# #     Name = "tf-test-ssh-security-group"
# #   }
# # }

# # Create Security Group for the Web Server
# resource "aws_security_group" "c_webserver_security_group" {
#   name        = "Webserver Security Group"
#   description = "Webserver sg for ingress and egress"
#   vpc_id      = aws_vpc.c_vpc.id

#   ingress {
#     description     = "HTTP access"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = ["${aws_security_group.c_app_lb_security_group.id}"]
#   }

#   ingress {
#     description     = "HTTPs access"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     security_groups = ["${aws_security_group.c_app_lb_security_group.id}"]
#   }

#   ingress {
#     description     = "api access"
#     from_port       = 80
#     to_port         = 30001
#     protocol        = "tcp"
#     security_groups = ["${aws_security_group.c_app_lb_security_group.id}"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "tf-test-webserver-security-group"
#   }
# }

# # Create Security Group for the Database
# resource "aws_security_group" "c_database_security_group" {
#   name        = "Database Security Group"
#   description = "Enable security group for Mysql"
#   vpc_id      = aws_vpc.c_vpc.id

#   ingress {
#     description     = "mysql access"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = ["${aws_security_group.c_webserver_security_group.id}"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "tf-test-database-security-group"
#   }
# }

# # Create Route Table and Add Public Route
# resource "aws_route_table" "c_public_route_table" {
#   vpc_id = aws_vpc.c_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.c_internet_gateway.id
#   }

#   tags = {
#     Name = "tf-test-public-route-table"
#   }
# }

# # Associate Public Subnet 1 to "Public Route Table"
# resource "aws_route_table_association" "c_public_subnet_az_a_route_table_link" {
#   subnet_id      = aws_subnet.c_public_subnet_az_a.id
#   route_table_id = aws_route_table.c_public_route_table.id
# }

# # Associate Public Subnet 2 to "Public Route Table"
# resource "aws_route_table_association" "c_public_subnet_az_b_route_table_link" {
#   subnet_id      = aws_subnet.c_public_subnet_az_b.id
#   route_table_id = aws_route_table.c_public_route_table.id
# }

# # Associate Public Subnet 3 to "Public Route Table"
# resource "aws_route_table_association" "c_public_subnet_az_c_route_table_link" {
#   subnet_id      = aws_subnet.c_public_subnet_az_c.id
#   route_table_id = aws_route_table.c_public_route_table.id
# }

