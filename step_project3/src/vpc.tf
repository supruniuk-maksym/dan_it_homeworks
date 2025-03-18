
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" 

  tags = {
    Name = "MyJenkinsVPC" 
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id 
  cidr_block              = "10.0.1.0/24" 
  map_public_ip_on_launch = true 
  availability_zone       = "ca-central-1a" 

  tags = {
    Name = "PublicSubnetJenkins" 
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id 
  cidr_block              = "10.0.2.0/24" 
  availability_zone       = "ca-central-1b" 

  tags = {
    Name = "PrivateSubnetJenkins" 
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id 

  tags = {
    Name = "MyInternetGatewayJenkins" 
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id 

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicRouteTableJenkins" 
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc" 
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id 
  subnet_id     = aws_subnet.public_subnet.id 

  tags = {
    Name = "MyNATGatewayJenkins" 
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id 

  route {
    cidr_block     = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.nat_gw.id 
  }

  tags = {
    Name = "PrivateRouteTableJenkins" 
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id 
  route_table_id = aws_route_table.private_rt.id 
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    public_instance_ip = aws_instance.public_instance.public_ip
    worker_private_ip  = aws_instance.private_instance.private_ip
  })
  filename = "${path.module}/inventory.ini"
}
