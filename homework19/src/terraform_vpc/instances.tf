
resource "aws_instance" "public_instance" {
  ami           = "ami-00498a47f0a5d4232" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_sg.id]

  associate_public_ip_address = true 

  tags = {
    Name = "PublicEC2"
  }
}

resource "aws_instance" "private_instance" {
  ami           = "ami-00498a47f0a5d4232"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.id]

  associate_public_ip_address = false  # Нет публичного IP

  tags = {
    Name = "PrivateEC2"
  }
}
