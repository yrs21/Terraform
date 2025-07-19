terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Nginx" {
    ami = "ami-0150ccaf51ab55a51"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.ngnix_sg.id]
    associate_public_ip_address = true
    user_data = <<-EOF
                   #!/bin/bash
                    sudo apt install nginx -y
                    sudo systemctl start nginx      
                   EOF
    tags = {
      name = "Nginx_Server"
    }
}

resource "aws_security_group" "ngnix_sg" {
    vpc_id = aws_vpc.test_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      name ="nginx_sg"
    }
}

output "url" {
  value = "https://${aws_instance.Nginx.public_ip}"
}
