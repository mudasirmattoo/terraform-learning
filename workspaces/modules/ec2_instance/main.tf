provider "aws" {
    region = "us-east-1"
}

variable "ami" {
  description = "This is AMI for the instance"
}

variable "instance_type" {
  description = "This is the instance type, for example: t2.micro"
}


resource "aws_key_pair" "deployer" {
  key_name   = "my-tf-key"
  public_key = file("/home/mudasirmattoo/.ssh/id_rsa.pub")
}

resource "aws_instance" "example" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
    tags = {
      Name = "vault-instance"
    }
}