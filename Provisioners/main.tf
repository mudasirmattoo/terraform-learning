provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
    default = "10.0.0.0/16"
}


resource "aws_key_pair" "sshkeypair" {
  key_name = "terraform-demo-key"
  public_key = file("~/.ssh/id_rsa.pub") 
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}


resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.myvpc
  cidr_block = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

