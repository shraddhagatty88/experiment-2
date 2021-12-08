############################################################################
# Variables:
############################################################################

############################################################################
# Tenancy:
############################################################################

variable "tenancy_ocid" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
variable "region" {}
variable "customer_label" {}

############################################################################
# Tags:
############################################################################

locals {
  tags = {
    "Account.StackName"          = ""
    "Account.StackOwner"         = ""
    "Account.ProjectName"        = ""
    "Account.BillingOwner"       = ""
    "Account.CompartmentName"    = ""
    "Billing.CostCentre"         = ""
    "Billing.Workload"           = ""
    "Billing.Environment"        = ""
  }
}

############################################################################
# IPs:
############################################################################

locals {
  ips = {
    vcn         = "10.199.0.0/20"
    sub_lb_int  = "10.199.0.2/26"
    sub_fss     = "10.199.0.65/26"
    sub_dmz     = "10.199.1.0/24"
    sub_app     = "10.199.2.0/24"
    sub_db      = "10.199.3.0/24"
    instances = {
      opsview   = "10.199.1.2"
      prodapp   = "10.199.2.3"
      drapp     = "10.199.2.4"
      devapp    = "10.199.2.5"
      testapp   = "10.199.2.6"
      proddb    = "10.199.3.2"
      drdb      = "10.199.3.3"
      devdb     = "10.199.3.4"
      testdb    = "10.199.3.5"
    }
  }
}

############################################################################
# Instances:
############################################################################

locals {
  ssh_keys = {
    nprd = "./files/ssh_gmp_nprd.pub"
  }
  oracle_images = {
    oel610_frankfurt = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa3krei33cetca6laoe3owjfsqllhjqnvr3jegstu7zsz6mkbszk5a"
    oel79_frankfurt  = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaf6gm7xvn7rhll36kwlotl4chm25ykgsje7zt2b4w6gae4yqfdfwa"
  }
  shapes = {
    e2-1m = "VM.Standard.E2.1.Micro"
    e2-1  = "VM.Standard.E2.1"
    e2-2  = "VM.Standard.E2.2"
    e2-4  = "VM.Standard.E2.4"
    s2-1  = "VM.Standard2.1"
    s2-2  = "VM.Standard2.2"
    s2-4  = "VM.Standard2.4"
    s2-8  = "VM.Standard2.8"
    s2-16 = "VM.Standard2.16"
    e3    = "VM.Standard.E3.Flex"
  }
  
}

############################################################################


variable "compartment_ocid" {}
variable "subnet_compartment" {} 

#########################################################################

### Compute Specific

variable "subnet_ocid1" {}

variable "availablity_domain_name" {
  default = "3"
}
variable "shape_ocpus" {
  default = 2
}
variable "shape_mem" {
  default = 16
}
variable "boot_volume_size_in_gbs" {
  default = 100
}
variable "backup_policy" {
  default = "silver"
}
variable instance_shape {
    default = "VM.Standard.E2.1"
}
variable "computeip_test" {}
variable "computeip_dev" {}
variable "ssh_key_nonprod" {}
variable "nsg" { 
  default     = []
  }
variable "instance_os" {}
variable "linux_os_version" {}


############################################################################

### DB Specific 
variable "subnet_ocid2" {}
variable "availablity_domain_name2" {
  default = "2"
}
variable "character_set" {
  default = "WE8MSWIN1252"
}
variable "db_ncharacter_set" {
  default = "AL16UTF16"
}
variable "db_edition" {
  default = "STANDARD_EDITION"
}
variable "db_version" {
  default = "19.12.0.0"
}
variable "data_storage_size_in_gb" {
  default = 256
}
variable "db_workload" {
  default = "OLTP"
}
variable "db_shape" {
  default = "VM.Standard2.2"
}

variable "ssh_key_db" {}


#####################################################################################################

#######Load Balancer Configuration#######

variable "subnet_ocid_lb" {}
variable "lb_shape" {}
variable "private_key1" {}
variable "public_certificate1" {}
variable "public_certificate2" {}
variable "ca_certificate1" {}

