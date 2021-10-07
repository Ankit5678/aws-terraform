variable "aws_region" {
  default     = "us-east-2"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

variable "az_count" {
  default     = "3"
  description = "number of availability zones in above region"
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_image" {
  default     = "324257953347.dkr.ecr.us-east-1.amazonaws.com/flask-demo-app:1.0"
  description = "docker image to run in this ECS cluster"
}

variable "app_port" {
  default     = "30001"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "3" #choose 3 bcz i have choosen 3 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}

variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
  type = string
}





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
