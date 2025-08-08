output "host_ip" {
  description = "Ansible Host public IP"
  value = module.ec2_instance_host.public_ip
  }

output "Node_ips" {
  description = "Ansible nodes public IP"
  value = module.ec2_instance_nodes[*].public_ip
}

output "mumbai_key_id" {
  description = "Key pair ID"
  value = aws_key_pair.deployer-mumbai.id
}

output "vpc_id" {
  description = "ID of ansible vpc created"
  value = aws_vpc.ansible-vpc.id  
}

output "pub_route_id"{
  description = "ID of public route table created"
  value = aws_route_table.host_public_route.id
}

