resource "aws_instance" "name" {
    ami = local.ami
    instance_type = local.instance_type
   
}