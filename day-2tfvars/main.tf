resource "aws_instance" "name" {
  ami = var.raj
  instance_type = var.type
}