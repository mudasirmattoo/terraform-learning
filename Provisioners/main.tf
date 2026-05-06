provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "demoSg" {
  name = "demoSg"
  vpc_id = var.demo_vpc_id

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "flask app"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = var.demo_vpc_id

  tags = {
    Name = "demoigw"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = var.public_subnet_ids[1]
  depends_on = [ aws_internet_gateway.ig ]

  tags = {
    Name = "demoNAT"
  }

}



resource "aws_route_table" "rtpublic" {
    vpc_id = var.demo_vpc_id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
    }

    tags = {
        Name = "PublicRouteTable"
    }
  
}


resource "aws_route_table_association" "rtpubassociation" {
    for_each = toset(var.public_subnet_ids)
    subnet_id = each.value
    route_table_id = aws_route_table.rtpublic.id
}


resource "aws_route_table" "rtprivate" {
    vpc_id = var.demo_vpc_id

    route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
    }
    
    tags = {
        Name = "PrivateRouteTable"
    }
  
}

resource "aws_route_table_association" "rtprivassociation" {
  for_each = toset(var.private_subnet_ids)

  subnet_id      = each.value
  route_table_id = aws_route_table.rtprivate.id
}


resource "aws_key_pair" "demo_key" {
  key_name   = "demo-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "demo" {
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id = var.ec2_subnet_id
  vpc_security_group_ids = [aws_security_group.demoSg.id]
  key_name = aws_key_pair.demo_key.key_name

  tags = {
    Name = "demoEC2"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("/home/mudasirmattoo/.ssh/id_rsa")
    host = self.public_ip
  }


  provisioner "file" {
    source = "app.py"
    destination = "/home/ubuntu/app.py"
  }

    provisioner "remote-exec" {
        inline = [
            "echo'hello from remote server Nigga'",
        "sudo apt-get update -y",
        "sudo apt-get install -y python3-pip python3-flask",
        "nohup sudo python3 /home/ubuntu/app.py > /dev/null 2>&1 &",
        "sleep 1" # Give the process a second to start before disconnecting
        ]
    }
}