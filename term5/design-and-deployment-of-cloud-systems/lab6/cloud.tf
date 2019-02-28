provider "google" {
  credentials = "${file("../clouds2018sg-a75521b2d0c3.json")}"
  project     = "clouds2018sg"
  region      = "europe-west3"
}

resource "google_container_cluster" "cluster" {
  name               = "lab6"
  zone               = "europe-west3-a"
  initial_node_count = 3

  node_config {
    machine_type = "n1-standard-1"
    image_type   = "COS"
  }
}

resource "google_sql_database_instance" "db_engine" {
  name             = "lab6"
  database_version = "POSTGRES_9_6"
  region           = "europe-west3"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      authorized_networks = [{
        value = "0.0.0.0/0"
      }]
    }
  }
}

resource "google_sql_database" "db" {
  instance = "${google_sql_database_instance.db_engine.name}"
  name     = "db"
}

resource "google_sql_user" "db_user" {
  instance = "${google_sql_database_instance.db_engine.name}"
  name     = "postgres"
  password = "postgres"
}

output "cluster_endpoint" {
  value = "${google_container_cluster.cluster.endpoint}"
}

output "database_ip" {
  value = "${google_sql_database_instance.db_engine.first_ip_address}"
}
