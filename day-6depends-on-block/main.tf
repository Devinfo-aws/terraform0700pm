resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
  
}

resource "aws_s3_bucket" "name" {
    bucket = "rajrajrajrajrajraj"
  depends_on = [ aws_instance.name ]
}