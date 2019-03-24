resource "google_compute_global_address" "private_ip_address" {
    name          = "private-ip-address"
    purpose       = "VPC_PEERING"
    address_type = "INTERNAL"
    prefix_length = 16
    network       = "${google_compute_network.my_vpc_network.self_link}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
    network       = "${google_compute_network.my_vpc_network.self_link}"
    service       = "servicenetworking.googleapis.com"
    reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}

resource "google_sql_database_instance" "instance" {
    depends_on = ["google_service_networking_connection.private_vpc_connection"]
    name = "${var.project}-db-instance"
    region = "us-central1"
    settings {
        tier = "db-f1-micro"
        ip_configuration {
            ipv4_enabled = "false"
            private_network = "${google_compute_network.my_vpc_network.self_link}"
        }
    }
}
resource "google_sql_database" "default" {
  name      = "${var.db_name}"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.instance.name}"
  charset   = "${var.db_charset}"
  collation = "${var.db_collation}"
}

resource "google_sql_user" "default" {
  name     = "${var.user_name}"
  project  = "${var.project}"
  instance = "${google_sql_database_instance.instance.name}"
  host     = "${var.user_host}"
  password = "${var.user_password}"
}