resource "google_compute_firewall" "default" {
  name    = "defaul23"
  network = "${google_compute_network.vpc_private.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http2"]
}