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
   metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
  }
}

