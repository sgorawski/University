variable servers_count {
  description = "Desired count of servers"
}

variable instance_type {
  description = "Instance type to use for a server"
}

variable site_dirpath {
  description = "Path to directory with site files"
}

variable ssh_key_filepath {
  description = "Path to ssh key used to connect to instances"
}

data "aws_vpc" "selected" {
  default = "true"
}

resource "aws_subnet" "appservers" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "${cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 10)}"

  tags {
    Name = "appservers"
  }
}

resource "aws_instance" "app" {
  count = "${var.servers_count}"

  ami                         = "ami-0b413adeb323658b1"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.appservers.id}"
  associate_public_ip_address = "true"
  key_name                    = "clouds2018"

  security_groups = ["${aws_security_group.appservers.id}"]

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
      ansible-playbook app-server.yml \
        -u admin \
        -i ${self.public_ip}, \
        --key-file ${var.ssh_key_filepath} \
        -e site_dirpath=${var.site_dirpath}
    EOF
  }

  tags {
    Name = "app${count.index}"
  }
}

output "server_pub_ips" {
  value = "${aws_instance.app.*.public_ip}"
}
