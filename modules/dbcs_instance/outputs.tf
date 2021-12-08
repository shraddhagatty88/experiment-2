# Outputs
output "db_display_name" {
  value = oci_database_db_system.tf_db.display_name
}

output "db_id" {
  value = oci_database_db_system.tf_db.id
}

output "db_state" {
  value = oci_database_db_system.tf_db.state
}

output "first-availability-domain_name" {
  value = data.oci_identity_availability_domains.ads.availability_domains[0].name
}
