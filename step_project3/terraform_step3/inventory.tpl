[master]
${public_instance_ip} 

[master:vars]
ansible_user=ubuntu 
ansible_ssh_private_key_file=/home/John/.ssh/aws_danit_maxsu_keys.pem

[worker]
${worker_private_ip} 

[worker:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/John/.ssh/aws_danit_maxsu_keys.pem
ansible_ssh_common_args='-o ProxyCommand="ssh -i /home/John/.ssh/aws_danit_maxsu_keys.pem ubuntu@${public_instance_ip} nc %h %p"'
master_ip=${public_instance_ip} 
