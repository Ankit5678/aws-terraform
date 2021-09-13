# Create Security Group for the Application Load Balancer
# terraform aws create security group
resource "aws_security_group" "app-lb-security-group" {
  name = "APP LB Security Group" 
  description = "Enable HTTP and HTTPs on port 80 and 443"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP access port 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs access on port 443"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-test-app-lb-security-group"
  }
}

# Create Security Group for the Bastion Host aka Jump Box
# terraform aws create security group
resource "aws_security_group" "ssh-security-group" {
  name = "ssh access security group"
  description = "Enable ssh access on port 22"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "ssh access on port 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-test-ssh-security-group"
  }
}

# Create Security Group for the Web Server
# terraform aws create security group
resource "aws_security_group" "webserver-security-group" {
  name = "Webserver Security Group"
  description = "Webserver sg for ingress and egress"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.app-lb-security-group.id}"]
  }

  ingress {
    description = "HTTPs access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = ["${aws_security_group.app-lb-security-group.id}"]
  }

  ingress {
    description = "ssh access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.ssh-security-group.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-test-webserver-security-group"
  }
}

# Create Security Group for the Database
# terraform aws create security group
resource "aws_security_group" "database-security-group" {
  name = "Database Security Group"
  description = "Enable security group for Mysql"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "mysql access"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.webserver-security-group.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-test-database-security-group"
  }
}