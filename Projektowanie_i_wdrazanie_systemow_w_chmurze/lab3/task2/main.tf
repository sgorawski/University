provider "google" {
  credentials = "${file("../../clouds2018sg-a75521b2d0c3.json")}"
  project     = "clouds2018sg"
  region      = "europe-west3"
}

resource "google_compute_network" "main" {
  name = "list3"
}

resource "google_compute_subnetwork" "appservers" {
  name          = "appservers"
  ip_cidr_range = "10.1.1.0/24"
  network       = "${google_compute_network.main.self_link}"
}

resource "google_compute_instance" "app" {
  name         = "appserver"
  machine_type = "f1-micro"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.appservers.self_link}"
    access_config = {}
  }

  tags = ["appserver"]

  metadata {
    sshKeys = "${file("../../gcp.pub")}"
  }
}

resource "google_compute_firewall" "allow_http" {
  name        = "http"
  network     = "${google_compute_network.main.name}"
  target_tags = ["appserver"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name        = "ssh"
  network     = "${google_compute_network.main.name}"
  target_tags = ["appserver"]

  source_ranges = ["156.17.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_sql_database_instance" "db" {
  name             = "main-db"
  database_version = "POSTGRES_9_6"
  region           = "europe-west3"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      authorized_networks {
        name  = "${google_compute_instance.app.name}"
        value = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
      }
    }
  }
}

output "appserver_pub_ip" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
}

output "database_pub_ip" {
  value = "${google_sql_database_instance.db.first_ip_address}"
}
