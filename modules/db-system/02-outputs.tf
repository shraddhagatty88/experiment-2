############################################################################
# Module Output Values:
############################################################################

output "db_system_id" {
    value = oci_database_db_system.db_system.id
}

output "db_system_ad" {
  value = oci_database_db_system.db_system.availability_domain
}

output "db_system_compartment" {
  value = oci_database_db_system.db_system.compartment_id
}

############################################################################