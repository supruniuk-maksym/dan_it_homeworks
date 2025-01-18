variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "list_of_open_ports" {
  description = "List of ports to open in the security group"
  type        = list(number)
}

variable "user_name" {
  description = "Unique login name to create a path for the S3 backend"
  type        = string
}