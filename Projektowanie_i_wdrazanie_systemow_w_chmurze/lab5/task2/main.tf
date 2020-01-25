provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

resource "aws_launch_configuration" "task2" {
  name            = "clouds2018-lab5-task2"
  image_id        = "ami-09ea2cb2a1b53c71d"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.asg.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "task2" {
  name                 = "clouds2018-lab5-task2"
  availability_zones   = ["eu-central-1a"]
  max_size             = 3
  min_size             = 3
  launch_configuration = "${aws_launch_configuration.task2.name}"

  health_check_type = "ELB"
  load_balancers    = ["${aws_elb.task2.name}"]
}

resource "aws_elb" "task2" {
  name               = "clouds2018-lab5-task2"
  availability_zones = ["eu-central-1a"]
  security_groups    = ["${aws_security_group.lb.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    target              = "HTTP:80/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
  }
}

output "elb_dns_name" {
  value = "${aws_elb.task2.dns_name}"
}
