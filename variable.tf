variable "vpc-cidr" {
  default = "10.0.0.0/16"
  description = "VPC CIDR"
  type = string
}

variable "public-subnet-1-cidr" {
  default = "10.0.0.0/24"
  description = "Public subnet 1 CIDR"
  type = string
}

variable "public-subnet-2-cidr" {
  default = "10.0.1.0/24"
  description = "Public subnet 2 CIDR"
  type = string
}

variable "public-subnet-3-cidr" {
  default = "10.0.2.0/24"
  description = "Public subnet 3 CIDR"
  type = string
}

variable "private-subnet-1-cidr" {
  default = "10.0.3.0/24"
  description = "Private subnet 1 for PHP-APP CIDR"
  type = string
}

variable "private-subnet-2-cidr" {
  default = "10.0.4.0/24"
  description = "Private subnet 2  for PHP-APP CIDR"
  type = string
}

variable "private-subnet-3-cidr" {
  default = "10.0.5.0/24"
  description = "Private subnet 3 for DB CIDR"
  type = string
}

variable "private-subnet-4-cidr" {
  default = "10.0.6.0/24"
  description = "Private subnet 4 for DB CIDR"
  type = string
}

variable "db-snapshot-identifier" {
  default = "arn:aws:rds:us-east-1:324257953347:snapshot:snapshot-1"
  description = "db ARN"
  type = string
}

variable "db-instance" {
  default = "db.t2.micro"
  description = "db instance type"
  type = string
}

variable "db-instance-identifier" {
  default = "mysqldb-1"
  description = "db instance identifier"
  type = string
}

variable "multi-az-deploy" {
  default = false
  description = "standby db"
  type = bool
}

variable "my_ami_image" {
  default = "ami-0c4b1c167f313ffe7"
  description = "my cent os image"
  type = string
}

variable "elastic_beanstalk_app" {
  default = "sdc-tf-test-app"
  description = "eb app"
  type = string
}

variable "elastic_beanstalk_appenv" {
  default = "sdc-tf-test-env"
  description = "eb env"
  type = string
}

variable "solution_stack_name" {
  default = "64bit Amazon Linux 2 v3.4.5 running Docker"
}

variable "tier" {
  default = "WebServer"
  type = string
}

variable "dns_prefix"{
  default = "sdc-tf-test-env-dns"
  type = string
}