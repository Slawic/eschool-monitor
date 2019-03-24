resource "google_compute_instance" "web" {
  count        = "${var.count}"
  name         = "${var.instance_name}-${count.index}"
  machine_type = "${var.machine_type}"
  tags = ["ssh","web"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
    #  access_config = {
    #  }
  }
  #   network_interface {
  #   subnetwork = "${google_compute_subnetwork.database_subnetwork.name}"
  #   #  access_config = {
  #   #  }
  # }

  metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install httpd

SCRIPT

  # metadata {
  #  sshKeys = "centos:${file("${var.public_key_path}")}"
  #}
}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "${var.machine_type}"
  tags = ["ssh"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  # network_interface {
  #   subnetwork = "${google_compute_subnetwork.public_subnetwork.name}"
  #    access_config = {
  #    }
  #}
    network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
      access_config = {
      }
  }

#   metadata_startup_script = <<SCRIPT
# sudo yum -y update
# sudo yum -y install httpd

# SCRIPT

  # metadata {
  #  sshKeys = "centos:${file("${var.public_key_path}")}"
  #}
}
