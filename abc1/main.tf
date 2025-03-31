resource "aws_instance" "name" {
    ami = "ami-071226ecf16aa7d96"
    instance_type = "t2.micro"
    key_name = "terraform"
    tags = {
      Name = "Terra"
    }
  
}
