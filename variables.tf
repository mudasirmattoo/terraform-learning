
variable "ami_id" {
  type = string
  description = "ec2 ami id"
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
}


variable "ec2_subnet_id" {
  type        = string
  description = "Subnet ID for EC2 instance"
}