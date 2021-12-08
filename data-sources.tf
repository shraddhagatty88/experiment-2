############################################################################
# Data Sources:
############################################################################
# Tenancy:

# Tenancy ID:
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

# Tenancy Availability Domains:
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

############################################################################
# Object Storage:

# Object Storage Services:
data "oci_core_services" "core_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# Object Storage Namespace:
data "oci_objectstorage_namespace" "tenancy_namespace" {
}

############################################################################
# State Files:

data "terraform_remote_state" "common_services" {
  backend = "http"
  config = {
    address = "https://objectstorage.uk-london-1.oraclecloud.com/p/VAXMazFbwaQJXaSjqxoBIZEr-PeCC479OrkH-s1FXxNPdMHBC_DNxBHzzsI6EFz1/n/lrf0onzyablx/b/terraform/o/gmp_common_services_terraform"
  }
}

############################################################################

#data "terraform_remote_state" "prod_services" {
#  backend = "s3"
#  config = {
#    bucket                      = "TFstates"
#    key                         = "amryt-prod-services.tfstate"
#    region                      = "eu-frankfurt-1"
#    endpoint                    = "https://frfqclpx4s18.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
#    profile                     = "amryt"
#    skip_region_validation      = true
#    skip_credentials_validation = true
#    skip_metadata_api_check     = true
#    force_path_style            = true
#  }
#}
