provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "key_tf" {
  key_name   = "key_tf"
  public_key = file("${path.module}/id_rsa.pub")
}

output "key_name" {
  value = aws_key_pair.key_tf.key_name
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id

   filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}
resource "aws_instance" "name" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.default.id
  key_name = aws_key_pair.key_tf.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

}

resource "aws_security_group" "web_sg" {
  vpc_id = data.aws_vpc.default.id
  name = "web_sg"

  dynamic "ingress" {
    for_each = [80,443,22]
    iterator = port
    content {
        description = "HTTP for vpc"
        from_port = port.value
        to_port = port.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "web_sg"
  }
}
