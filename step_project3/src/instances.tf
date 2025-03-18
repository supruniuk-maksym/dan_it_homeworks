variable "private_key" {
  default = "/home/John/.ssh/aws_danit_maxsu_keys.pem"
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-00498a47f0a5d4232"  
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "aws_danit_maxsu_keys"  
  vpc_security_group_ids = [aws_security_group.public_sg.id]  

  associate_public_ip_address = true 

user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    mkdir -p /home/ubuntu/.ssh
    chmod 700 /home/ubuntu/.ssh

    touch /home/ubuntu/.ssh/known_hosts
    chmod 644 /home/ubuntu/.ssh/known_hosts

    ssh-keyscan ${aws_instance.private_instance.private_ip} >> /home/ubuntu/.ssh/known_hosts
  EOF

  tags = {
    Name = "MasterJenkinsEC2"
  }

  provisioner "file" {
    source      = var.private_key
    destination = "/home/ubuntu/.ssh/aws_danit_maxsu_keys.pem"
  }

  provisioner "remote-exec" {
  inline = [
    "chmod 600 /home/ubuntu/.ssh/aws_danit_maxsu_keys.pem",
    "chown ubuntu:ubuntu /home/ubuntu/.ssh/aws_danit_maxsu_keys.pem"
  ]
}

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key)
    host        = self.public_ip
  }
}

resource "aws_instance" "private_instance" {
  ami                    = "ami-00498a47f0a5d4232"  
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = "aws_danit_maxsu_keys"  
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  associate_public_ip_address = false  

  tags = {
    Name = "WorkerJenkinsEC2"
  }
}

output "worker_private_ip" {
  value = aws_instance.private_instance.private_ip
}
