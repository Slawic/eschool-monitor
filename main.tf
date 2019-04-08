resource "google_compute_instance" "web" {
  count        = "${var.count}"
  name         = "${var.instance_name}-${count.index}"
  machine_type = "${var.machine_type}"
  tags = ["ssh","web"]
  zone = "${element(var.azs, count.index)}"
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
 
  }
 
  metadata_startup_script = <<SCRIPT
sudo yum -y update

SCRIPT

  metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
  }

}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "n1-standard-1"
  tags = ["ssh"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
    access_config = {
      }
  }
   metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
   }

   metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install ansible
# install monitoring agent
curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
sudo bash install-monitoring-agent.sh
SCRIPT
}

resource "google_monitoring_alert_police" "alert_policy" {
  display_name = "busy_application"
  combiner = "OR"
  conditions {
    display_name = "condition metric 60secs"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
      duration = "${var.metric_value}"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period = "${var.metric_value}"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
  }
}

