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