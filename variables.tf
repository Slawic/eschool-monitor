variable "key" {
  default = "devops-a162f31edb27.json"
}
variable "project" {
  default = "devops-235312"
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
variable "ip_cidr_range_privet" {
    default = "10.0.1.0/24"
}
variable "ip_cidr_range_db" {
    default = "10.0.100.0/24"
}
variable "public_key_path" {
  description = "Path to file containing public key"
  default     = ".ssh/id_rsa.pub"
}
//Database variable
variable database_version {
  description = "The version of of the database. `MYSQL_5_6`"
  default     = "MYSQL_5_6"
}
variable tier {
  description = "The machine tier or type. See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing"
  default     = "db-f1-micro"
}
variable ip_configuration {
  description = "The ip_configuration settings subblock"
  type        = "list"
  default     = [{ipv4_enabled = "false", private_network = "${google_compute_network.private_network.self_link}"}]
}
variable db_instance_name {
  description = "The name of the master instance"
  default     = "master-instance"
}
variable disk_autoresize {
  description = "Second Generation only. Configuration to increase storage size automatically."
  default     = true
}

variable disk_size {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  default     = 10
}

variable disk_type {
  description = "Second generation only. The type of data disk: `PD_SSD` or `PD_HDD`."
  default     = "PD_SSD"
}
variable backup_configuration {
  description = "The backup_configuration settings subblock for the database setings"
  type        = "map"
  default     = {}
}
variable db_name {
  description = "Name of the default database to create"
  default     = "eschool_db"
}

variable db_charset {
  description = "The charset for the default database"
  default     = "utf8"
}

variable db_collation {
  description = "The collation for the default database. Example for MySQL databases: 'utf8_general_ci', and Postgres: 'en_US.UTF8'"
  default     = "utf8"
}

variable user_name {
  description = "The name of the default user"
  default     = "root"
}

variable user_host {
  description = "The host for the default user"
  default     = "%"
}

variable user_password {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  default     = ""
}
