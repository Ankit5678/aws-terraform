variable "c_vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
  type        = string
}

variable "az_a" {
  default = "us-east-2a"
  type    = string
}

variable "az_b" {
  default = "us-east-2b"
  type    = string
}

variable "az_c" {
  default = "us-east-2c"
  type    = string
}

variable "c_public_subnet_az_a_cidr" {
  default = "10.0.1.0/24"
  type    = string
}

variable "c_public_subnet_az_b_cidr" {
  default = "10.0.2.0/24"
  type    = string
}

variable "c_public_subnet_az_c_cidr" {
  default = "10.0.3.0/24"
  type    = string
}

variable "c_private_subnet_az_a_cidr" {
  default = "10.0.4.0/24"
  type    = string
}

variable "c_private_subnet_az_b_cidr" {
  default = "10.0.5.0/24"
  type    = string
}

variable "c_private_subnet_az_c_cidr" {
  default = "10.0.6.0/24"
  type    = string
}

variable "c_elastic_beanstalk_application_name" {
  default = "c-app"
  type    = string
}

variable "c_elastic_beanstalk_environment_name" {
  default = "c-app-env"
  type    = string
}

variable "c_elastic_beanstalk_configuration_name" {
  default = "c-app-config"
  type    = string
}

variable "c_solution_stack_name" {
  default = "64bit Amazon Linux 2 v3.4.5 running Docker"
  type    = string
}

variable "c_app_tier" {
  default = "WebServer"
  type    = string
}

variable "c_app_dns_prefix" {
  default = "c-tf-test-env-dns"
  type    = string
}
