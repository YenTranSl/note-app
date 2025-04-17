variable "region" {
  default = "ap-southeast-1"
}

variable "instance_name" {
  description = "Tên EC2 instance"
  default     = "note-app"
}

variable "instance_ami" {
  description = "AMI ID cho EC2"
  default     = "ami-07e1c21044c364605"
}

variable "instance_type" {
  default = "t2.micro"
}
