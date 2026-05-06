
variable "ec2_subnet_id" {
  type = string
}


variable "ami_id" {
    type = string
}

variable "demo_vpc_id" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}


variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}