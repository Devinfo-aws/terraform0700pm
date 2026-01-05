resource "aws_instance" "name" {
 ami = "ami-068c0051b15cdb816"
 instance_type = "t3.micro"
 tags = {
    name = "test"
 }


}

resource "aws_s3_bucket" "dev" {
    bucket = "llaadduu"
  
}