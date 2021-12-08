module "instance_test_app" {
  source                  = "./modules/core_instance"
  tenancy_id              = var.tenancy_ocid
  display_name            = "${var.customer_label}_oci_test_app"
  vnic_hostname_label     = "${var.customer_label}ocitestapp"
  shape                   = var.instance_shape
  shape_ocpus             = var.shape_ocpus
  shape_mem               = var.shape_mem
  availability_domain     = var.availablity_domain_name
  fault_domain            = 2
  compartment_id          = var.compartment_ocid
  subnet_id               = var.subnet_ocid1
  network_sec_groups      = [ var.nsg ]
  ssh_authorized_keys     = var.ssh_key_nonprod
  source_id               = "ocid1.image.oc1.uk-london-1.aaaaaaaahm2udvgllrsptv6q3afrduo6tpuqa2ti6fcst5gt3myc7zsfocmq"
  boot_volume_size_in_gbs = 100
  assign_public_ip        = false
  private_ip              = var.computeip_test
  boot_backup_policy      = "silver"
  defined_tags            = local.tags
}

resource "oci_file_storage_file_system" "test_transfer_fss" {
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")
  compartment_id = data.terraform_remote_state.common_services.outputs.nprd_services_compartment_id
  display_name = "test_transfer_fss"
  defined_tags       = local.tags
  lifecycle {
      ignore_changes = [
          defined_tags["Oracle-Tags.CreatedBy"],
          defined_tags["Oracle-Tags.CreatedOn"],
          defined_tags["Account.Created_By"],
          defined_tags["Account.Created_At"],
      ]
  }
}
resource "oci_file_storage_export_set" "test_transfer_export_set" {
  mount_target_id = data.terraform_remote_state.common_services.outputs.nprd_mount_target
}
resource "oci_file_storage_export" "test_transfer_export" {
  export_set_id  = oci_file_storage_export_set.test_transfer_export_set.id
  file_system_id = oci_file_storage_file_system.test_transfer_fss.id
  path           = "/test_transfer"
    export_options {
    source                         = "10.199.0.0/22"
    access                         = "READ_WRITE"
    identity_squash                = "NONE"
    require_privileged_source_port = true
  }
}




