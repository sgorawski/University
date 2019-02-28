provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

resource "aws_instance" "server" {
  ami                         = "ami-0b413adeb323658b1"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  key_name                    = "clouds2018"

  security_groups = ["${aws_security_group.allow_all.name}"]

  provisioner "file" {
    source      = "run.sh"
    destination = "run.sh"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file("../../clouds2018.pem")}"
    }
  }

  provisioner "remote-exec" {
    script = "conf.sh"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file("../../clouds2018.pem")}"
    }
  }

  tags {
    Name = "lab4-server"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    from_port   = 0
    to_port     = 65535
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

data "aws_vpc" "selected" {
  default = "true"
}

output "public_ip" {
  value = "${aws_instance.server.public_ip}"
}
