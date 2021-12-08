# Variables
variable "compartment_id"      { type = string }
variable "db_admin_password"   { type = string }
variable "db_name"             { type = string }
variable "db_public_keys"      { type = list(string) }
variable "db_subnet_id"        { type = string }
variable "db_display_name"     { type = string }
variable "db_pdb_name"         { type = string }
variable "db_hostname"         { type = string }
variable "db_host_domain"      { type = string }
variable "db_storage_gb"       { type = number }

variable "db_workload" {
  type    = string
  default = "OLTP"
}

variable "db_version" {
  type    = string
  default = "21.1.0.0"
}

variable "db_shape" {
  type    = string
  default = "VM.Standard2.1"
}

variable "db_database_edition" {
  type    = string
  default = "ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
}

variable "db_license_model" {
  type    = string
  default = "LICENSE_INCLUDED"
}

variable "db_node_count" {
  type    = number
  default = 1
}


# Resources
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

