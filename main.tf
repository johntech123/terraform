provider "aws" {
    region= "us-east-2"
  
}

resource "aws_instance" "example" {
    ami = "ami-04f167a56786e4b09"
    instance_type = "t2.micro"

    tags = {
    Name = "MyExampleInstance"
  }
}

