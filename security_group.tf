##Creating host security group with SSH & HTTPS rule
resource "aws_security_group" "host-vpc-sg" {
  name        = "host-vpc-sg"
  vpc_id      = aws_vpc.ansible-vpc.id
  tags = var.resources_tag
}

#Adding ingress rule for SSH & HTTPS & ICMP in master host security group
resource "aws_vpc_security_group_ingress_rule" "ssh-http-ICMP" {
  security_group_id = aws_security_group.host-vpc-sg.id
  cidr_ipv4   = "0.0.0.0/0"
  for_each=tomap({
    "tcp" = "22",
    "ICMP" = "-1",
    "TCP" = "443"
})
  from_port   = each.value
  ip_protocol = each.key
  to_port     = each.value
}


#creating security group for node instances with ssh & HTTPS access from ansible master host & own public IP
resource "aws_security_group" "node-vpc-sg" {
  name        = "node-vpc-sg"
  vpc_id      = aws_vpc.ansible-vpc.id
  tags = var.resources_tag
}

##adding ingress rule for only ssh & HTTPS 
resource "aws_vpc_security_group_ingress_rule" "ssh-cidr" {
  security_group_id = aws_security_group.node-vpc-sg.id
  cidr_ipv4 = "0.0.0.0/0"            
  for_each=tomap({
    "TCP" = "22"
    "TCP" = "443"
})
  from_port   = each.value
  ip_protocol = each.key
  to_port     = each.value
}




#adding egress rule with allowed all traffic to both the master host & nodes instances security group
resource "aws_vpc_security_group_egress_rule" "egress" {
  depends_on = [ aws_security_group.host-vpc-sg, aws_security_group.node-vpc-sg]

#creating a map to pass individual host & nose security group id's to argument security_group_id
  for_each = tomap({
    "host_sg" = aws_security_group.host-vpc-sg.id,
    "node_sg" = aws_security_group.node-vpc-sg.id
})


  security_group_id = each.value          #passing security group ids from above for_each function
  cidr_ipv4   = "0.0.0.0/0"
#  from_port   = 0
  ip_protocol = -1
 # to_port     = 0
}



