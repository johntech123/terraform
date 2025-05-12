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

resource "aws_instance" "name" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_tf.key_name
}

