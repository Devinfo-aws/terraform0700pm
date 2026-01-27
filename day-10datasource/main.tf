data "aws_subnet" "name" {
    filter {
    name = "tag:Name"
    values = ["dev-function"]
    }
  
}

resource "aws_instance" "name" {
    subnet_id = data.aws_subnet.name.id
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
  
}