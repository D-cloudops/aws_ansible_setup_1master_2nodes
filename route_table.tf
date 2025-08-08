#resource block to create route table for public instance(ansible host machine)
resource "aws_route_table" "host_public_route" {
  vpc_id = aws_vpc.ansible-vpc.id
# since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"                                    
    gateway_id = aws_internet_gateway.ansible-pub-gateway.id
  }
  route {
    cidr_block = var.vpc_cidr   #mentioning cidr of VPC 
    gateway_id = "local"
  }
}


/*
#creating provate route table routes
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.ansible-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ansible_nat.id
  }
   route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
}
*/

#associating public subnet with public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.ansible-pub-subnet.id
  route_table_id = aws_route_table.host_public_route.id
}

/*
#associating private subnet with private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.custom-private-subnet.id
  route_table_id = aws_route_table.private_route.id
}
*/