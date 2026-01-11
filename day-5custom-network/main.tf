resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "dev"
    }
  
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "dev"
  }

}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "test"
    }
  
}

resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
  tags = {
    Name = "dev-ig"
  }
}

resource "aws_internet_gateway_attachment" "name" {
    internet_gateway_id = aws_internet_gateway.name.id
    vpc_id = aws_vpc.name.id
  
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
    }
  
}


resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
  
}

# Creation Security Group
resource "aws_security_group" "dev_sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "dev-sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [ aws_security_group.dev_sg.id ]
    tags = {
      Name = "dev"
    }
  
}
  
resource "aws_instance" "private" {
    ami = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [ aws_security_group.dev_sg.id ]
  tags = {
    Name = "test"
  }
}

resource "aws_eip" "name" {
    instance = aws_instance.private.id
  
}

resource "aws_eip_association" "name" {
    instance_id = aws_instance.private.id
    allocation_id = aws_eip.name.id
  
}

resource "aws_nat_gateway" "private" {
    allocation_id = aws_eip.name.id
    subnet_id = "i-02d4a58f804ae9bb2"
    tags = {
      Name = "pr-nat"
    }
  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private.id
        
    }
  
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_instance.private.id
    route_table_id = aws_route_table.private.id
  
}