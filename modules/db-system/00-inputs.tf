############################################################################
# Module Input Variables:
############################################################################
# Database:

variable "availability_domain" {}

variable "compartment_id" {}

variable "db_edition" {}
# STANDARD_EDITION
# ENTERPRISE_EDITION
# ENTERPRISE_EDITION_HIGH_PERFORMANCE
# ENTERPRISE_EDITION_EXTREME_PERFORMANCE

variable "db_admin_password" {
    default = "AzR-3789_DNua-kba2"
}

variable "db_auto_backup_enabled" {
    default = "true"
}

variable "character_set" {}

variable "db_name" {}
variable "pdb_name" {}

variable "db_workload" {
  default = "OLTP"
}

variable "db_ncharacter_set" {
  default = "AL16UTF16"
}

variable "db_version" {}

variable "hostname" {}

variable "db_shape" {}

variable "ssh_public_keys" {}

variable "subnet_id" {}

# variable "db_storage_percentage" {
#   default = "80"
# }

variable "data_storage_size_in_gb" {}

variable "db_disk_redundancy" {
  default = "HIGH"
}

variable "db_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "db_source" {
  default = "NONE"
}

variable "display_name" {}

variable "node_count" {
  default = "1"
}

# variable "db_storage_management" {
#   default = "LVM"
# }

variable "network_sec_groups" {
  default = []
}

############################################################################
# Data Guard:

variable "create_data_guard" {
  default = false
}

variable "data_guard_creation_type" {
  default = "NewDbSystem"
}

variable "data_guard_protection_mode" {
  default = "MAXIMUM_PERFORMANCE"
}

variable "data_guard_transport_type" {
  default = "ASYNC"
}

variable "data_guard_delete_standby" {
  default = "true"
}

variable "data_guard_availability_domain" {
  default = ""
}

variable "data_guard_display_name" {
  default = ""
}

variable "data_guard_hostname" {
  default = ""
}

variable "data_guard_subnet_id" {
  default = ""
}

############################################################################

variable "defined_tags" {
    type = map
}
