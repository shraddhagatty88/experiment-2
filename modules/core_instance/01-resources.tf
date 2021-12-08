############################################################################
# Module Definition:
############################################################################
# Data Sources:

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_id
}

data "oci_identity_fault_domains" "fault_domains" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1]["name"]
  compartment_id      = var.compartment_id
}

data "oci_core_volume_backup_policies" "boot_backup_policy" {
  filter {
    name   = "display_name"
    values = [var.boot_backup_policy]
  }
}

############################################################################
# Core Instance:

resource "oci_core_instance" "instance" {
  availability_domain                 = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1]["name"]
  compartment_id                      = var.compartment_id
  shape                               = var.shape
  display_name                        = var.display_name
  fault_domain                        = data.oci_identity_fault_domains.fault_domains.fault_domains[var.fault_domain - 1]["name"]
  is_pv_encryption_in_transit_enabled = var.is_pv_encryption_in_transit_enabled
  preserve_boot_volume                = var.preserve_boot_volume
  defined_tags                        = var.defined_tags
  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = var.assign_public_ip
    display_name           = var.display_name
    hostname_label         = var.vnic_hostname_label
    private_ip             = var.private_ip
    skip_source_dest_check = var.skip_source_dest_check
    nsg_ids                = var.network_sec_groups
  }
  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = var.user_data
  }
  source_details {
    source_id               = var.source_id
    source_type             = var.source_type
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }
  shape_config {
    memory_in_gbs = var.shape_mem
    ocpus         = var.shape_ocpus
  }

  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
      defined_tags["Account.Created_By"],
      defined_tags["Account.Created_At"],
    ]
  }
}

############################################################################
# Boot Volume Backup Policy:

resource "oci_core_volume_backup_policy_assignment" "volume_backup_policy_assignment" {
  count     = var.create_boot_backup_policy ? var.instance_count : 0
  asset_id  = element(oci_core_instance.instance.*.boot_volume_id, count.index)
  policy_id = data.oci_core_volume_backup_policies.boot_backup_policy.volume_backup_policies[0]["id"]
}

############################################################################

resource "oci_core_volume" "apps_bv" {
  availability_domain   = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1]["name"]
  compartment_id        = var.compartment_id
  display_name          = "${var.display_name}_apps_bv"
  size_in_gbs           = 200
  defined_tags          = var.defined_tags
}

resource "oci_core_volume_attachment" "attach_apps_bv" {
  attachment_type     = "Paravirtualized"
  instance_id         = oci_core_instance.instance.id
  volume_id           = oci_core_volume.apps_bv.id
}

resource "oci_core_volume_backup_policy_assignment" "apps_bv_bkp" {
  asset_id = oci_core_volume.apps_bv.id
  policy_id = data.oci_core_volume_backup_policies.boot_backup_policy.volume_backup_policies[0]["id"]
}
