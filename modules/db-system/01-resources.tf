############################################################################
# Module Definition:
############################################################################
# Database System:

resource "oci_database_db_system" "db_system" {
    availability_domain = var.availability_domain
    compartment_id = var.compartment_id
    database_edition = var.db_edition
    db_home {
        database {
            admin_password = var.db_admin_password
            character_set = var.character_set
            db_backup_config {
                auto_backup_enabled = var.db_auto_backup_enabled
                recovery_window_in_days = 30
            }
            db_name = var.db_name
            db_workload = var.db_workload
            ncharacter_set = var.db_ncharacter_set
            defined_tags   = var.defined_tags 
            pdb_name = var.pdb_name
            tde_wallet_password = "Version_One_12"
        }
        db_version   = var.db_version
        display_name = var.db_name
        # defined_tags = var.defined_tags 
    }
    hostname = var.hostname
    shape = var.db_shape
    ssh_public_keys = [var.ssh_public_keys]
    subnet_id = var.subnet_id
    # data_storage_percentage = var.db_storage_percentage
    data_storage_size_in_gb = var.data_storage_size_in_gb
    disk_redundancy = var.db_disk_redundancy
    display_name = var.display_name
    license_model = var.db_license_model
    source = var.db_source
    node_count = var.node_count
    defined_tags   = var.defined_tags
    lifecycle {
        ignore_changes = [
            defined_tags["Oracle-Tags.CreatedBy"],
            defined_tags["Oracle-Tags.CreatedOn"],
            defined_tags["Account.Created_By"],
            defined_tags["Account.Created_At"],
            db_home[0].database[0].admin_password,
            db_home[0].database[0].defined_tags["Oracle-Tags.CreatedBy"],
            db_home[0].database[0].defined_tags["Oracle-Tags.CreatedOn"],
            db_home[0].database[0].defined_tags["Account.Created_By"],
            db_home[0].database[0].defined_tags["Account.Created_At"],
            ssh_public_keys
        ]
    }
    # db_system_options {
    #     storage_management = var.db_storage_management
    # }
    nsg_ids = var.network_sec_groups
  timeouts {
    create = "5h"
    delete = "5h"
  }
}

############################################################################
# Data Guard Association (Optional):

data "oci_database_db_homes" "db_system_db_homes" {
  compartment_id = var.compartment_id
  db_system_id   = oci_database_db_system.db_system.id
}

data "oci_database_databases" "db_system_databases" {
  compartment_id = var.compartment_id
  db_home_id     = data.oci_database_db_homes.db_system_db_homes.db_homes.0.db_home_id
}

resource "oci_database_data_guard_association" "data_guard_association" {
    # Optional flag:
    count                  = var.create_data_guard ? 1 : 0
    
    #Required
    creation_type           = var.data_guard_creation_type
    database_admin_password = var.db_admin_password
    database_id             = data.oci_database_databases.db_system_databases.databases.0.id
    protection_mode         = var.data_guard_protection_mode
    transport_type          = var.data_guard_transport_type
    delete_standby_db_home_on_delete = var.data_guard_delete_standby

    #Optional
    availability_domain     = var.data_guard_availability_domain
    display_name            = var.data_guard_display_name
    hostname                = var.data_guard_hostname
    # peer_db_system_id       = oci_database_peer_db_system.test_peer_db_system.id
    subnet_id               = var.data_guard_subnet_id
}

############################################################################
