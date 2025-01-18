resource "aws_instance" "nginx_server" {
  ami           = "ami-09a9858973b288bdd"  # Ubuntu 22.04 AMI
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true
  subnet_id     = module.vpc.public_subnets[0]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "nginx-instance"
  }
}