provider "aws" {
    region= "us-east-2"
  
}

resource "aws_instance" "example" {
    ami = var.ami_id
    instance_type = var.instance_type

    tags = {
    Name = var.instance_name
  }
}



