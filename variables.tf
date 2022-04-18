variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS Region to use for resources"
  default     = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base VPC cidr block"
  default     = "172.31.0.0/16"
}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR block for subnet in VPC"
  default     = ["172.31.1.0/24", "172.31.2.0/24", "172.31.101.0/24", "172.31.102.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "Company name for resources tagging"
  default     = "JnbTech"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}

variable "aws_key_pair" {
  type        = string
  description = "Private key name for SSH connection"
  default     = "tf-elb-key"
}