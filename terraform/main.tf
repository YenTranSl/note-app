# Configure AWS Provider
provider "aws" {
  profile = "se400"
  region  = var.region
}

# Create EC2 Instance
resource "aws_instance" "se400" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.se400.key_name
  user_data     = file("init.sh")
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids = [aws_security_group.note_sg.id]
}

# Create Security Group with required access
resource "aws_key_pair" "se400" {
  key_name   = "se400_key_pair"
  public_key = file("../.ssh/id_rsa.pub")
}

resource "aws_security_group" "note_sg" {
  name = "note-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}