# create VPC
# 
# create custom route table
# create public subnet for lb Subnets
# associate subnet with route table
# create security group
# create nats gateway for public to private subnet conection
# create a private ecr

# VPC
resource "aws_vpc" "c_vpc" {
  cidr_block           = var.c_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-test-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "c_internet_gateway" {
  vpc_id = aws_vpc.c_vpc.id

  tags = {
    Name = "tf-test-igw"
  }
}

# Public Subnets
resource "aws_subnet" "c_public_subnet_az_a" {
  vpc_id                  = aws_vpc.c_vpc.id
  cidr_block              = var.c_public_subnet_az_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-test-public-subnet-a"
  }
}

resource "aws_subnet" "c_public_subnet_az_b" {
  vpc_id                  = aws_vpc.c_vpc.id
  cidr_block              = var.c_public_subnet_az_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-test-public-subnet-b"
  }
}

resource "aws_subnet" "c_public_subnet_az_c" {
  vpc_id                  = aws_vpc.c_vpc.id
  cidr_block              = var.c_public_subnet_az_c_cidr
  availability_zone       = var.az_c
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-test-public-subnet-c"
  }
}

# Private Subnets
resource "aws_subnet" "c_private_subnet_az_a" {
  vpc_id                  = aws_vpc.c_vpc.id
  cidr_block              = var.c_private_subnet_az_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-test-private-subnet-a"
  }
}

resource "aws_subnet" "c_private_subnet_az_b" {
  vpc_id                  = aws_vpc.c_vpc.id
  cidr_block              = var.c_private_subnet_az_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-test-private-subnet-b"
  }
}

resource "aws_subnet" "c_private_subnet_az_c" {
  vpc_id                  = aws_vpc.c_vpc.id
  cidr_block              = var.c_private_subnet_az_c_cidr
  availability_zone       = var.az_c
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-test-private-subnet-c"
  }
}

# Create security groups
# Create Security Group for the Application Load Balancer
resource "aws_security_group" "c_app_lb_security_group" {
  name        = "APP LB Security Group"
  description = "Enable HTTP and HTTPs on port 80 and 443"
  vpc_id      = aws_vpc.c_vpc.id

  ingress {
    description = "HTTP access port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs access on port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-test-app-lb-security-group"
  }
}

# # Create Security Group for the Bastion Host aka Jump Box
# resource "aws_security_group" "ssh-security-group" {
#   name = "ssh access security group"
#   description = "Enable ssh access on port 22"
#   vpc_id = aws_vpc.vpc.id

#   ingress {
#     description = "ssh access on port 22"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "tf-test-ssh-security-group"
#   }
# }

# Create Security Group for the Web Server
resource "aws_security_group" "c_webserver_security_group" {
  name        = "Webserver Security Group"
  description = "Webserver sg for ingress and egress"
  vpc_id      = aws_vpc.c_vpc.id

  ingress {
    description     = "HTTP access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.c_app_lb_security_group.id}"]
  }

  ingress {
    description     = "HTTPs access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.c_app_lb_security_group.id}"]
  }

  ingress {
    description     = "api access"
    from_port       = 80
    to_port         = 30001
    protocol        = "tcp"
    security_groups = ["${aws_security_group.c_app_lb_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-test-webserver-security-group"
  }
}

# Create Security Group for the Database
resource "aws_security_group" "c_database_security_group" {
  name        = "Database Security Group"
  description = "Enable security group for Mysql"
  vpc_id      = aws_vpc.c_vpc.id

  ingress {
    description     = "mysql access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.c_webserver_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-test-database-security-group"
  }
}

# Create Route Table and Add Public Route
resource "aws_route_table" "c_public_route_table" {
  vpc_id = aws_vpc.c_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.c_internet_gateway.id
  }

  tags = {
    Name = "tf-test-public-route-table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
resource "aws_route_table_association" "c_public_subnet_az_a_route_table_link" {
  subnet_id      = aws_subnet.c_public_subnet_az_a.id
  route_table_id = aws_route_table.c_public_route_table.id
}

# Associate Public Subnet 2 to "Public Route Table"
resource "aws_route_table_association" "c_public_subnet_az_b_route_table_link" {
  subnet_id      = aws_subnet.c_public_subnet_az_b.id
  route_table_id = aws_route_table.c_public_route_table.id
}

# Associate Public Subnet 3 to "Public Route Table"
resource "aws_route_table_association" "c_public_subnet_az_c_route_table_link" {
  subnet_id      = aws_subnet.c_public_subnet_az_c.id
  route_table_id = aws_route_table.c_public_route_table.id
}

# Create elastic beanstalk application
resource "aws_elastic_beanstalk_application" "c_elastic_beanstalk_application" {
  name = var.c_elastic_beanstalk_application_name
}

# Create elastic beanstalk Environment
resource "aws_elastic_beanstalk_environment" "c_elastic_beanstalk_environment" {
  name                = var.c_elastic_beanstalk_environment_name
  application         = aws_elastic_beanstalk_application.c_elastic_beanstalk_application.name
  solution_stack_name = var.c_solution_stack_name
  tier                = var.c_app_tier
  cname_prefix        = var.c_app_dns_prefix
}

# Elastic Beanstalk Configuration
resource "aws_elastic_beanstalk_configuration_template" "c_elastic_beanstalk_configuration_template" {
  name                = var.c_elastic_beanstalk_configuration_name
  application         = var.c_elastic_beanstalk_application_name
  solution_stack_name = var.c_solution_stack_name
  environment_id      = var.c_elastic_beanstalk_environment_name

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 3"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Cooldown"
    value     = "300"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Custom Availability Zones"
    value     = "'${var.az_a}','${var.az_b}','${var.az_c}'"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "EnableCapacityRebalancing"
    value     = "false"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "3"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "10"
  }

  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "BlockDeviceMappings"
  # }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = "true"
  }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "EC2KeyName"
  # }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "IamInstanceProfile"
  #     value = "aws-elasticbeanstalk-ec2-role"
  # }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "ImageId"
  #     resource = "AWSEBEC2LaunchTemplate"
  #     value = "ami-081e3132ab4de11a6"
  # }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "MonitoringInterval"
    value     = "5 minute"
  }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "RootVolumeIOPS"
  # }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "RootVolumeSize"
  #     resource = "AWSEBEC2LaunchTemplate"
  # }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "RootVolumeThroughput"
  #     resource = "AWSEBEC2LaunchTemplate"
  # }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "RootVolumeType"
  #     resource = "AWSEBEC2LaunchTemplate"
  # }
  # setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name = "SSHSourceRestriction"
  #     value = "tcp,22,22,0.0.0.0/0"
  # }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    # value = "security-group-for-inbound-nfs-d-pgnc9h3ceagh,security-group-for-outbound-nfs-d-pgnc9h3ceagh,awseb-e-yghitzseka-stack-AWSEBSecurityGroup-1W3NTTKC03O9Q"
    value = "'${aws_security_group.c_webserver_security_group.id}','${aws_security_group.c_database_security_group.id}'"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "BreachDuration"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "EvaluationPeriods"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = "-1"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "20"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "RequestCount"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Period"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Count"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "60"
  }
  # setting {
  #       namespace = "aws:autoscaling:updatepolicy:rollingupdate"
  #       name = "MaxBatchSize"
  #       resource = "AWSEBAutoScalingGroup"
  #   }
  #   setting {
  #       namespace = "aws:autoscaling:updatepolicy:rollingupdate"
  #       name = "MinInstancesInService"
  #       resource = "AWSEBAutoScalingGroup"
  #   }
  #   setting {
  #       namespace = "aws:autoscaling:updatepolicy:rollingupdate"
  #       name = "PauseTime"
  #       resource = "AWSEBAutoScalingGroup"
  #   }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "false"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Time"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "Timeout"
    value     = "PT30M"
  }
  setting {
    namespace = "aws:ec2:instances"
    name      = "EnableSpot"
    value     = "false"
  }
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = true
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "'${aws_subnet.c_public_subnet_az_a.id}','${aws_subnet.c_public_subnet_az_b.id}','${aws_subnet.c_public_subnet_az_c.id}'"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "DBSubnets"
    value     = "'${aws_subnet.c_private_subnet_az_a.id}','${aws_subnet.c_private_subnet_az_b.id}','${aws_subnet.c_private_subnet_az_c.id}'"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "'${aws_subnet.c_private_subnet_az_a.id}','${aws_subnet.c_private_subnet_az_b.id}','${aws_subnet.c_private_subnet_az_c.id}'"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.c_vpc.id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "http://localhost:30001/"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "30"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "DeleteOnTerminate"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "RetentionInDays"
    value     = "30"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "30"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "IgnoreHealthCheck"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "Timeout"
    value     = "600"
  }
  setting {
    namespace = "aws:elasticbeanstalk:control"
    name      = "DefaultSSHPort"
    value     = "22"
  }
  setting {
    namespace = "aws:elasticbeanstalk:control"
    name      = "LaunchTimeout"
    value     = "0"
  }
  setting {
    namespace = "aws:elasticbeanstalk:control"
    name      = "LaunchType"
    value     = "Migration"
  }
  setting {
    namespace = "aws:elasticbeanstalk:control"
    name      = "RollbackLaunchOnFailure"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ExternalExtensionsS3Bucket"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ExternalExtensionsS3Key"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerIsShared"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "arn:aws:iam::324257953347:role/aws-elasticbeanstalk-service-role"
  }
}
