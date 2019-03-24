provider "google" {
  credentials = "${file("${var.key}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}
provider "google-beta" {
  credentials = "${file("${var.key}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}