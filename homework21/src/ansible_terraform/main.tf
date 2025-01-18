provider "aws" {
  region = "ca-central-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ca-central-1a"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-0a474b3a85d51a5e5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "aws_danit_maxsu_keys" 
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "AnsibleInstance-${count.index}"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    instances = aws_instance.web[*].public_ip
  })
  filename = "${path.module}/inventory.ini"
}

resource "local_file" "ansible_playbook" {
  content  = <<EOT
---
- name: Setup Docker and Nginx
  hosts: servers
  become: true

  tasks:
    - name: Install required packages
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
        state: present

    - name: Add Docker GPG key
      shell: |
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
      args:
        executable: /bin/bash

    - name: Add Docker repository
      shell: |
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      args:
        executable: /bin/bash

    - name: Update package cache and install Docker
      apt:
        update_cache: yes
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
        state: present

    - name: Install Docker Compose
      get_url:
        url: "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-{{ ansible_architecture }}"
        dest: "/usr/local/bin/docker-compose"
        mode: 'u+x,g+x'

    - name: Create Docker Compose directory
      file:
        path: /opt/nginx
        state: directory

    - name: Create Docker Compose file
      copy:
        dest: /opt/nginx/docker-compose.yml
        content: |
          version: '3'
          services:
            nginx:
              image: nginx:latest
              ports:
                - "80:80"

    - name: Start Nginx with Docker Compose
      shell: "docker-compose -f /opt/nginx/docker-compose.yml up -d"
EOT
  filename = "${path.module}/playbook.yml"
}
