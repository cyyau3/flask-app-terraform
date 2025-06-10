# variables.tf

variable "my_ip_cidr" {
  description = "Current local public IP address"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
    description = "CIDR block for public subnet"
    type = string
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
    description = "CIDR block for private subnet-1"
    type = string
    default = "10.0.2.0/24"
}

variable "private_subnet_cidr_block-2" {
    description = "CIDR block for private subnet-2"
    type = string
    default = "10.0.3.0/24"
}

variable "db_name" {
  description = "RDS DB name"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}