variable "appserver_ips" {
  type        = "list"
  description = "IP addresses of application servers"
}

variable "ssh_key_filepath" {
  description = "Path to ssh key file used to connect to instance"
}

data "aws_vpc" "selected" {
  default = "true"
}

resource "aws_subnet" "load_balancer" {
  vpc_id                  = "${data.aws_vpc.selected.id}"
  cidr_block              = "${cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 11)}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "load_balancer"
  }
}

resource "aws_instance" "load_balancer" {
  ami           = "ami-0b413adeb323658b1"
  instance_type = "t2.micro"
  key_name      = "clouds2018"
  subnet_id     = "${aws_subnet.load_balancer.id}"

  security_groups = ["${aws_security_group.load_balancer.id}"]

  provisioner "remote-exec" {
    inline = ["sudo apt-get -y install python"]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file(var.ssh_key_filepath)}"
    }
  }

  provisioner "local-exec" {
    command = <<EOF
      ansible-playbook load-balancer.yml \
        -u admin \
        -i ${self.public_ip}, \
        --key-file ${var.ssh_key_filepath} \
        -e '{"appserver_ips": ${jsonencode(var.appserver_ips)}}'
    EOF
  }

  tags {
    Name = "load_balancer"
  }
}

resource "aws_eip" "lb_ip" {
  instance = "${aws_instance.load_balancer.id}"

  tags {
    Name = "load_balancer"
  }
}

output "server_pub_ip" {
  value = "${aws_eip.lb_ip.public_ip}"
}
