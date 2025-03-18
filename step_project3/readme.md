The Goal of Step_project3:

1. Set Up AWS Infrastructure with Terraform:
**●     Create S3 Bucket:
**○     Create an S3 bucket to store Terraform state files.
●     Define VPC and Networking:
○     Use Terraform to create a Virtual Private Cloud (VPC) with public and private subnets. 1 public (Jenkins master) and 1 private (Jenkins worker)
○     Set up Internet Gateway and NAT Gateway.
●     Launch EC2 Instances:
○     Add your ssh-key for access to EC2 in public subnet.
○     Create a security group to allow SSH and HTTP access.
○     Launch on-demand EC2 instance for Jenkins master and spot instance for Jenkins worker within the created subnets. Add your public SSH key using terraform user-data.
○     Use variables and output values to manage configurations.
2. Set Up Jenkins master with Ansible:
●     Write an Ansible playbook to install Jenkins on the deployed EC2 instance.
●     Install nginx and configure it as a reverse proxy for Jenkins web server using Ansible
3. Set Up Jenkins
●     Add a Jenkins worker to the Jenkins master.
●     Deploy the same pipeline from Step project 2 and check if it's working as expected.
4. Destroy all resources in the end.
Note: all deployment code (Terrafrom, Ansible, Jenkinsfile etc) should be stored in the GitHub repository.
=====================================================================================================================================

Notes:
S3 AWS BUCKET: 
name:   max-supru-step-project-3 
region: Canada (Central) ca-central-1

My folder with filed (temporary)
/home/vagrant/dan_it_homeworks/step_project3/terraform_step3

Temporary info:

public_instance_ip = "35.183.86.163 "
worker_private_ip = "10.0.2.114"


My note commands I used for studing
1. to log to public machine 
ssh -i /home/John/.ssh/aws_danit_maxsu_keys.pem ubuntu@35.183.86.163 
ssh -i /home/ubuntu/.ssh/aws_danit_maxsu_keys.pem ubuntu@10.0.2.114
ssh -i /home/John/.ssh/aws_danit_maxsu_keys.pem ubuntu@10.0.2.114 


2. to JUMP to private machine throug public maching
ssh -o "ProxyCommand ssh -i /home/John/.ssh/aws_danit_maxsu_keys.pem ubuntu@115.223.68.207 nc %h %p"     -i /home/John/.ssh/aws_danit_maxsu_keys.pem ubuntu@10.0.2.168

3. Ansible 
ansible-playbook -i inventory.ini jenkins-setup.yml
ansible-playbook -i inventory.ini jenkins-worker.yml

4. Jenkins
- take password to the Jenkins server
ssh -i /home/John/.ssh/aws_danit_maxsu_keys.pem ubuntu@15.156.194.77 \
"sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

- Agent test noda command
curl -sO http://15.156.194.77/jnlpJars/agent.jar
java -jar agent.jar -url http://15.156.194.77/ -secret 6d25f4a36d56201732459f2d255610a6063ddccd4558edac400949537a992a1f -name test -webSocket -workDir "/home/jenkins"

"docker --version"

