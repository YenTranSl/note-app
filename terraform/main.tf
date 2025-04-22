# Cau hinh Provider AWS
provider "aws" {
  profile = "se400"
  region  = var.region
}

# Tao cap khoa SSH
resource "aws_key_pair" "se400" {
  key_name   = "se400_key_pair"
  public_key = file("D:/Seminar_CNPM/.ssh/id_rsa.pub")
}

# Tao may chu EC2
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}