[servers]
%{ for ip in instances ~}
${ip}
%{ endfor ~}

[servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/John/.ssh/aws_danit_maxsu_keys.pem
ansible_python_interpreter=/usr/bin/python3
ansible_shell_executable=/bin/bash
