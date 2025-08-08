#resource block to create custom gatway
resource "aws_internet_gateway" "ansible-pub-gateway" {
  vpc_id = aws_vpc.ansible-vpc.id
  
  tags = var.resources_tag
}

#uncomment the below section if needed nodes in private subnet and to create NAT GATEWAY

/*
#Assiging elastic IP 
resource "aws_eip" "elastic-ip" {
  domain = "vpc"
}

#resoure block to create NAT gateway on public subnet 
resource "aws_nat_gateway" "ansible_nat" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.ansible-pub-subnet.id

  tags = var.resources_tags 
}
*/