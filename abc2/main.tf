#create vpc

resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "dev"
    }
  
}
#create internet gateway and attach to vpc

resource "aws_internet_gateway" "cust" {
    vpc_id = aws_vpc.test.id
    tags = {
      Name = "cust_ig"
    }
  
}
#create subnets

resource "aws_subnet" "cust" {
    vpc_id = aws_vpc.test.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "pub_sub"
    }
  
}
#create Route tables enable routing IG to RT

resource "aws_route_table" "cust" {
    vpc_id = aws_vpc.test.id

route {
    gateway_id = aws_internet_gateway.cust.id
    cidr_block = "0.0.0.0/0"
}
}
#subnet association add subnet into rt

resource "aws_route_table_association" "cust" {
    route_table_id = aws_route_table.cust.id
    subnet_id = aws_subnet.cust.id
    
}
#create security groups

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.test.id
  tags = {
    Name = "cust_sg"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  }
#Launch instance

resource "aws_instance" "pub_ec2" {
    ami = "ami-02b49a24cfb95941c"
    instance_type = "t2.micro"
    key_name = "terraform"
    subnet_id = aws_subnet.cust.id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
  
}