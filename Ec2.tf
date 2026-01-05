provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "virgina2"

  vpc_security_group_ids = [
    aws_security_group.allow_all_and_5000.id
  ]
  user_data = << EOF

    #!/bin/bash

    yum update -y

    yum install httpd -y

    service httpd start

    chkconfig httpd on

    cd /var/www/html

    echo "<html><h1>Hello Cloud Gurus Welcome To My Webpage</h1></html>" >

    index.html

  EOF
  tags = {
    Name = "flak-deployment"
  }
}
