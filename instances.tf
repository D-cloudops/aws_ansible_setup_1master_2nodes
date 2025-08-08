#create  key pair from a locally generated key 
resource "aws_key_pair" "deployer-mumbai" {
  key_name   = "key-local-mumbai"
  public_key = file("ssh_key_host/key_id_rsa.pub")
}

#using aws ec2 module to create ec2 instances
module "ec2_instance_host" {
  #this resource will only provision after security group are successfully created
  depends_on = [aws_security_group.host-vpc-sg , aws_security_group.node-vpc-sg]
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "ansible_host"                # naming Instance
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer-mumbai.key_name
  user_data = file("ansible_install.sh")     # using userdata to install ansible on this host
  subnet_id     = aws_subnet.ansible-pub-subnet.id
  associate_public_ip_address = true       #Associating public IP to the instance
  create_security_group = false 
  vpc_security_group_ids = [aws_security_group.host-vpc-sg.id]
  tags = var.resources_tag
}

# Creating a null resource for copying the private key to the master host for keyless authentication 
 resource "null_resource" "copying_Private_key" {
      # Ensuring this null_resource runs after the EC2 instance is created
      depends_on = [module.ec2_instance_host]

    #added a trigger for the provisioner in order for need to execute each time we execute terraform apply
      triggers = {
            always_run = timestamp()
          }

  # Define the connection block for remote-exec or file provisioners
      connection {
        type        = "ssh"
        user        = "ec2-user" # Or appropriate user for your AMI
        host        = module.ec2_instance_host.public_ip
        private_key =  file("ssh_key_host/key_id_rsa")   # Path of private key to connect to master host
      }
    
      provisioner "file" {
        source      = "ssh_keyless_keys/keyless_id_rsa"   #source  path to the private key for keyless authentication
        destination = "/home/ec2-user/.ssh/id_rsa"      #destination path to copy the private key 
      }

 }

#creating node instances
module "ec2_instance_nodes" {
  #this resource will only provision after security group are successfully created
  depends_on = [aws_security_group.host-vpc-sg , aws_security_group.node-vpc-sg]
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "ansible_node_${count.index }"
  ami = var.ami
  instance_type = var.instance_type
#for non-billing i am not using private subnet Henceforth i am launching in public subnet
# Uncomments the private subnet/NAT gateway sections on security_group.tf & gateway.tf files respectively
# update the subnet id to aws_subnet.ansible-private-subnet.id  if needed to launch instance in private subnet
  subnet_id     = aws_subnet.ansible-pub-subnet.id

#If launching nodes in private subnet do update the below value as false
  associate_public_ip_address = true       # since launched in public subnet so associating true

  key_name = aws_key_pair.deployer-mumbai.key_name
  create_security_group = false 
  vpc_security_group_ids = [aws_security_group.node-vpc-sg.id]
  count = 2
  tags = var.resources_tag
}

#Null resource created for provisioner to copy the public key to the authorized keys file in nodes instances
 resource "null_resource" "copying_public_key_to_nodes" {
    # Ensure this null_resource runs after the EC2 instance is created
      depends_on = [module.ec2_instance_nodes]
    #added a trigger for the provisioner in order for need to execute each time we execute terraform apply
       triggers = {
            always_run = timestamp()
          }

      count = length(module.ec2_instance_nodes)   #taking the count of no.of instance created
  # Define the connection block for remote-exec or file provisioners
      connection {
        type        = "ssh"
        user        = "ec2-user" # Or appropriate user for your AMI
        host        = module.ec2_instance_nodes[count.index].public_ip  #Extracting the public ip of each node instance
        private_key =  file("ssh_key_host/key_id_rsa")    # # Path of private key to connect to master host
      }
      
      # Example: Use a remote-exec provisioner to install Nginx
      provisioner "remote-exec" {
      #under file function give path of public key for keyless authentication 
        inline = [
          "echo '${file("ssh_keyless_keys/keyless_id_rsa.pub")}'>>/home/ec2-user/.ssh/authorized_keys"
        ]
      }
 }
       
 
 
