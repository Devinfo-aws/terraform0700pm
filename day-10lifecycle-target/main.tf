
#target specific resource to terraform init, plan & apply

resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    tags = {
      Name = "dev_env"
    }
  
}

resource "aws_s3_bucket" "name" {
    bucket = "devinfo-awsfunction"
  
}

