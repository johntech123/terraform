provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "key_tf" {
  key_name   = "key_tf"
  public_key = file("${path.module}/id_rsa.pub")
}

