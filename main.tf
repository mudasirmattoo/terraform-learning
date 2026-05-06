terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "s3_example" {
  bucket = "terraform-s3-bucket-mudasirdevops-2026"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_example.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_instance" "terraform-ec2-example" {
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id = var.ec2_subnet_id
}