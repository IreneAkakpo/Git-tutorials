# Creating EC2 instance
resource "aws_instance" "server" {
  ami                         = "ami-00785f4835c6acf64" # eu-west-2
  instance_type               = "t2.micro"
  key_name                    = "Irene-KP"
  vpc_security_group_ids      = [aws_security_group.Irene-SG.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet1.id

  tags = {
    "name" = "server"
  }
}
