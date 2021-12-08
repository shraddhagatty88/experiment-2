resource "oci_database_db_system" "dbcs_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  db_home {
    database {
      admin_password = var.db_admin_password
      db_name        = var.db_name
      db_workload    = var.db_workload
      pdb_name       = var.db_pdb_name
    }
    db_version = var.db_version
  }
  hostname                = var.db_hostname
  shape                   = var.db_shape
  ssh_public_keys         = var.db_public_keys
  subnet_id               = var.db_subnet_id
  display_name            = var.db_display_name
  data_storage_size_in_gb = var.db_storage_gb
  database_edition        = var.db_database_edition
  domain                  = var.db_host_domain
  license_model           = var.db_license_model
  node_count              = var.db_node_count
  defined_tags        = merge(
                          local.tags
                          ,map("Schedule.AnyDay", "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1") # TMP: ON (24x7)                        # ,map("Schedule.WeekDay", "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1") # BAU: M-F 6-6
                        )
}
resource "oci_database_database" "test_database" {
    #Required
    database {
        #Required
        admin_password = var.database_database_admin_password
        db_name = var.database_database_db_name

        #Optional
        backup_id = oci_database_backup.test_backup.id
        backup_tde_password = var.database_database_backup_tde_password
        character_set = var.database_database_character_set
        database_software_image_id = oci_database_database_software_image.test_database_software_image.id
        db_backup_config {

            #Optional
            auto_backup_enabled = var.database_database_db_backup_config_auto_backup_enabled
            auto_backup_window = var.database_database_db_backup_config_auto_backup_window
            backup_destination_details {

                #Optional
                id = var.database_database_db_backup_config_backup_destination_details_id
                type = var.database_database_db_backup_config_backup_destination_details_type
            }
            recovery_window_in_days = var.database_database_db_backup_config_recovery_window_in_days
        }
        db_unique_name = var.database_database_db_unique_name
        db_workload = var.database_database_db_workload
        defined_tags = var.database_database_defined_tags
        freeform_tags = var.database_database_freeform_tags
        ncharacter_set = var.database_database_ncharacter_set
        pdb_name = var.database_database_pdb_name
        tde_wallet_password = var.database_database_tde_wallet_password
    }
    db_home_id = oci_database_db_home.test_db_home.id
    source = var.database_source

    #Optional
    db_version = var.database_db_version
    kms_key_id = oci_kms_key.test_key.id
    kms_key_version_id = oci_kms_key_version.test_key_version.id
}
