#Create VPC
resource "aws_vpc" "test_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "myvpc"
    }
}

#public subnet
resource "aws_subnet" "public_subnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.test_vpc.id
    map_public_ip_on_launch = true
    tags = {
      name = "public_subnet"
    }
}

#private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    name = "private_subnet"
  }
}
# internet gateway
resource "aws_internet_gateway" "int_gtw" {
    vpc_id = aws_vpc.test_vpc.id
    tags = {
      name = "int_gtw"
    }
}

#routing
resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.test_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.int_gtw.id
    }
}

resource "aws_route_table_association" "pub_sub" {
    route_table_id = aws_route_table.route_table.id
    subnet_id = aws_subnet.public_subnet.id
}
