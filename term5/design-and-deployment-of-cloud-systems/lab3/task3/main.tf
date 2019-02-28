provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

module "appservers" {
  source = "./appservers/"

  servers_count    = "3"
  instance_type    = "t2.micro"
  site_dirpath     = "./assets/site/"
  ssh_key_filepath = "../../clouds2018.pem"
}

module "load_balancer" {
  source = "./load_balancer/"

  appserver_ips    = "${module.appservers.server_pub_ips}"
  ssh_key_filepath = "../../clouds2018.pem"
}

output "appserver_ips" {
  value = "${module.appservers.server_pub_ips}"
}

output "load_balancer_ip" {
  value = "${module.load_balancer.server_pub_ip}"
}
