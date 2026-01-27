#terraform import by instance_id with no changes

resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
  
}

#terraform import s3 bucket by using bucket_name with no changes 

resource "aws_s3_bucket" "name" {
    bucket = "rajrajrajrajrajraj"
  
}
