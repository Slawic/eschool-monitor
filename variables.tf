variable "key" {
  default = "DevOps-f87e91d062e3.json"
}
variable "project" {
  default = "devops-233521"
}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-a"
}
variable "machine_type" {
  default = "g1-small"
}
variable "image" {
    default = "centos-cloud/centos-7"
}
variable "instance_name" {
    default = "web"
}
variable "count" {
    default = "1"
}
variable "ip_cidr_range" {
    default = "10.0.1.0/24"
}
variable "public_key_path" {
  description = "Path to file containing public key"
  default     = ".ssh/id_rsa.pub"
}