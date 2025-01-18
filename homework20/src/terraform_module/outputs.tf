output "instance_ip" {
  description = "Public IP of the created EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}
