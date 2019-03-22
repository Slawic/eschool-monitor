resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "privet_subnetwork" {
  name          = "test-subnetwork"
  ip_cidr_range = "${var.ip_cidr_range_privet}"
  region        = "${var.region}"
  network       = "${google_compute_network.vpc_network.self_link}"
}

resource "google_compute_subnetwork" "database_subnetwork" {
  name          = "test-subnetwork"
  ip_cidr_range = "${var.ip_cidr_range_db}"
  region        = "${var.region}"
  network       = "${google_compute_network.vpc_network.self_link}"
}
resource "google_compute_router" "router" {
  name    = "router"
  region  = "${google_compute_subnetwork.subnetwork.region}"
  network = "${google_compute_network.vpc_network.self_link}"
  bgp {
    asn = 64514
  }
}
resource "google_compute_router_nat" "simple-nat" {
  name                               = "nat-1"
  router                             = "${google_compute_router.router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
