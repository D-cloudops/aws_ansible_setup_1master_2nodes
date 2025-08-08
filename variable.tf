variable "region" {
   description = "select the region to deploy resources"
   type = string
}

variable "ami" {
    description = "AMI-ID for the ec2-instance"  
    type = string
}

variable "instance_type" {
  description = "Instance type"
  type = string
}

variable "resources_tag" {
  description = "tags to apply to all resources"
  type = map(string)
  default= {
  terrafrom_provision = "true"
  }
}

variable "vpc_cidr" {
  description = "cidr block of VPC"
  type = string
}

variable "pub_subnet_cidr" {
  description = "cidr block of public subnet"
  type = string
}

variable "pvt_subnet_cidr" {
  description = "cidr block of private subnet"
  type = string
}

variable "public_az" {
  description = "AZ of public subnet"
}

variable "private_az" {
  description = "AZ of private subnet"
}

