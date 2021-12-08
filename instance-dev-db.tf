############################################################################
# DB System:
#############################################################################

module "db-system-dev" {
  source                         = "./modules/db-system"
  availability_domain            = var.availablity_domain_name2
  compartment_id                 = var.compartment_ocid
  subnet_id                      = var.subnet_ocid2
  db_edition                     = var.db_edition
  character_set                  = var.character_set
  db_workload                    = var.db_workload
  db_ncharacter_set              = var.db_ncharacter_set
  db_name                        = "CDBDEV"
  pdb_name                       = "DEV"
  db_version                     = var.db_version
  db_shape                       = var.db_shape
  ssh_public_keys                = var.ssh_key_db
  data_storage_size_in_gb        = var.data_storage_size_in_gb
  hostname                       = "${var.customer_label}DEVDB"
  display_name                   = "${var.customer_label}DEVDB"
  defined_tags                   = local.tags
  network_sec_groups             = [ var.nsg ]
  create_data_guard              = false
}

############################################################################

