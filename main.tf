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
 
  }
 
  metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install httpd

SCRIPT

  metadata {
    sshKeys = "centos:${file("f:/SSHkey/devops095.pub")}"
  }

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

  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
    access_config = {
      }
  }
   metadata {
    sshKeys = "centos:${file("f:/SSHkey/devops095.pub")}"
   }
  #  provisioner "file" {
  #   source = "f:/SSHkey/devops095_ossh.pem"
  #   destination = "/home/centos/.ssh/"
  #   }

   metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install ansible
SCRIPT
}
resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "ghghgh"
  target                = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
}

resource "null_resource" remoteExecProvisionerWFolder {
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("f:/SSHkey/devops095_ossh.pem")}"
    agent = "false"
  }  
  provisioner "remote-exec" {
    inline = [ "rm -rf /tmp/ansible" ]
  }
  provisioner "file" {
    source = "ansible"
    destination = "/tmp/ansible"
  }

  provisioner "file" {
    source = "f:/SSHkey/devops095_ossh.pem"
    destination = "/home/centos/.ssh/id_rsa"
   }

  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }

}
