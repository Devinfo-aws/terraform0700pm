resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    tags = {
      Name = "dev_env"
    }
}

#unable to destroy a server by enabling "true"

 #lifecycle {
 #   prevent_destroy = true
  #   } 

#creates a another server before destroying the current server 

#lifecycle {
  #create_before_destroy = true
#}
#}


#ignore the changes in server

# lifecycle {
# ignore_changes = [ instance_type, ]
# }