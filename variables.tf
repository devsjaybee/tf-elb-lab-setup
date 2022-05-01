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

##################################################################################
# NETWORKS
##################################################################################

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

##################################################################################
# TG HEALTH CHECK
##################################################################################

variable "health_check_path" {
  default     = "/"
  type        = string
  description = "The destination for the health check request."
}

variable "health_check_port" {
  default     = "80"
  type        = string
  description = "The port to use to connect with the target."
}

variable "health_check_healthy_threshold" {
  default     = "3"
  type        = string
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy."
}

variable "health_check_unhealthy_threshold" {
  default     = "3"
  type        = string
  description = "The number of consecutive health check failures required before considering the target unhealthy."
}

variable "health_check_timeout" {
  default     = "5"
  type        = string
  description = "The amount of time, in seconds, during which no response means a failed health check."
}

variable "health_check_interval" {
  default     = "10"
  type        = string
  description = "The approximate amount of time, in seconds, between health checks of an individual target."
}

variable "health_check_matcher" {
  default     = "200"
  type        = string
  description = "The HTTP codes to use when checking for a successful response from a target."
}

variable "health_check_protocol" {
  default     = "HTTP"
  type        = string
  description = "The protocol to use to connect with the target."
}


variable "app_health_check_path" {
  default     = "/appserverinfo.py"
  type        = string
  description = "The destination for the health check request."
}

variable "app_health_check_port" {
  default     = "8080"
  type        = string
  description = "The port to use to connect with the target."
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