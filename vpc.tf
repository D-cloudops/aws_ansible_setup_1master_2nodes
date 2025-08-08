#resource block to create vpc 

resource "aws_vpc" "ansible-vpc" {
  
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = var.resources_tag
}

#Resource block to create public subnet
resource "aws_subnet" "ansible-pub-subnet" {
    vpc_id = aws_vpc.ansible-vpc.id
    availability_zone = var.public_az
    cidr_block = var.pub_subnet_cidr
    map_public_ip_on_launch = true
    tags = var.resources_tag
}

/*
#resource block to create private subnet
resource "aws_subnet" "ansible-private-subnet" {
    vpc_id = aws_vpc.ansible-vpc.id
    availability_zone = var.private_az
    cidr_block = var.pvt_subnet_cidr
    map_public_ip_on_launch = false
    tags = var.resources_tag
}
*/

