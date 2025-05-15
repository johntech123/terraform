provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "in_az" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

resource "aws_instance" "dell" {
  instance_type = "t2.micro"
  ami = "ami-084568db4383264d4"
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = aws_key_pair.deployer.key_name
  subnet_id = data.aws_subnets.in_az.ids[0]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash  
sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<html><body><h1>Hello Shahrukh, you nailed it!</h1></body></html>" > /var/www/html/index.nginx-debian-html
EOF

  

  provisioner "file" {
    source      = "./script.txt"
    destination = "/tmp/script.txt"

      connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("${path.module}/key1")
    host     = self.public_ip
  }
}


  tags = {
    Name = "provissioner"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/key1.pub")
}

variable "port" {
  type = list(number)
  default = [ 22,80,443 ]
}

resource "aws_security_group" "sg" {
  name = "sg_new"
  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.port
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
       from_port =  0
       to_port =  0
       protocol =  "-1"
       cidr_blocks =  ["0.0.0.0/0"]
    }

   tags = {
    Name = "sg_new"
  }
} 





