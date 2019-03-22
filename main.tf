resource "google_compute_instance" "web" {
  count        = "${var.count}"
  name         = "${var.instance_name}-${count.index}"
  machine_type = "${var.machine_type}"
  tags = ["http"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnetwork.name}"
    access_config = {
    }
  }
  # metadata {
  #  sshKeys = "centos:${file("${var.public_key_path}")}"
  #}
}
resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "ghghgh"
  target                = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
}

resource "google_compute_target_pool" "default" {
  project          = "${var.project}"
  name             = "lbs3"
  region           = "${var.region}"
  session_affinity = "NONE"

  health_checks = [
    "${google_compute_http_health_check.default.name}",
  ]
}

resource "google_compute_http_health_check" "default" {
  project      = "${var.project}"
  name         = "hg-hc"
  request_path = "/"
  port         = "80"
}
