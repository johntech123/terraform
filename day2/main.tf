provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "demo" {
  cidr_block = var.cidr_block

tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo.id

   tags = {
     Name = "${var.vpc_name}-igw"

  }
}

resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"


  tags = {
    Name = "private_subnet"
  }
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.demo.id
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_security_group" "sg" {
   name = "web_sg" 
   vpc_id = aws_vpc.demo.id

  

   ingress {
    description = "HTTP for vpc"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
    description = "ssh for vpc"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }

    tags = {
    Name = var.sg_name
 }
}

resource "aws_instance" "example" {
  instance_type = var.instance_type
  ami = var.ami_value
  subnet_id = aws_subnet.sub1.id
  associate_public_ip_address = var.enable_public_ip

  tags = {
    Name = "public_instance"
  }
}

resource "aws_instance" "hello" {
  instance_type = var.instance_type
  ami = var.ami_value
  subnet_id = aws_subnet.sub2.id

  tags = {
    Name = "private_instance"
  }
}




  

