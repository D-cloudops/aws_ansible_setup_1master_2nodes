 ## IAC code for Setting up an Ansible practice environment on AWS.

 ### Goal
 
 Setup up one master host having ansible pre-installed and two nodes with keyless authentication enabled from master host.

 ### pre-requisite
 1. Terraform installed
 2. AWS connection set up
 3. Two SSH keys generated- one for connecting to the instances and other for keyless authentication
    > ansible -m pem -t rsa -b 2048 -f ssh_key_host/key_id_rsa
    
    > ansible -m pem -t rsa -b 2048 -f ssh_keyless_keys/keyless_id_rsa
    


 
