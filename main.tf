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
sudo yum -y install httpd
sudo systemctl start httpd
sudo rpm -ivh https://d2znqt9b1bc64u.cloudfront.net/java-1.8.0-amazon-corretto-devel-1.8.0_202.b08-2.x86_64.rpm

SCRIPT

  metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
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
    sshKeys = "centos:${file("${var.public_key_path}")}"
   }
  #  provisioner "file" {
  #   source = "f:/SSHkey/devops095_ossh.pem"
  #   destination = "/home/centos/.ssh/"
  #   }

   metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install ansible
yum install -y mc nano wget git
#install java amazon corretto JDK and JRE
wget https://d1f2yzg3dx5xke.cloudfront.net/java-1.8.0-amazon-corretto-devel-1.8.0_202.b08-1.amzn2.x86_64.rpm
wget https://d1f2yzg3dx5xke.cloudfront.net/java-1.8.0-amazon-corretto-1.8.0_202.b08-1.amzn2.x86_64.rpm
yum localinstall -y java-1.8.0-amazon-corretto*.rpm
#enable the Jenkins repository
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
#add the repository to system
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
#install the latest stable version of Jenkins
yum install -y jenkins
#start the Jenkins service
systemctl start jenkins
#enable the Jenkins service to start on system boot
systemctl enable jenkins
SCRIPT
}

resource "null_resource" remoteExecProvisionerWFolder {
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
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
    source = "${var.private_key_path}"
    destination = "/home/centos/.ssh/id_rsa"
   }

  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }

}
