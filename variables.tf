variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID"
  default     = "ami-0166fe664262f664c" # AMI for my region
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  default     = "benkeypair" #This is my us-east-1 keypair name
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  default     = ["192.168.192.0/20", "192.168.208.0/20"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  default     = ["192.168.224.0/20", "192.168.240.0/20"]
}

# variable "availability_zones" {
#   description = "List of availability zones to use"
#   default     = ["us-east-1a", "us-east-1b"]
# }

variable "certificate_arn" {
  default = "arn:aws:acm:us-east-1:992382645606:certificate/b748f7c0-0213-4fd6-acbd-d5dff990f1f4"
}

variable "tags" {
  default = {
    Environment = "Testing"
    Project     = "Ben's Project"
  }
}