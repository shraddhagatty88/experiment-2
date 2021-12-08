############################################################################
# nprd - Internal Load Balancer:
############################################################################

resource "oci_load_balancer_load_balancer" "nprd_int_lb" {
    compartment_id             = var.compartment_ocid
    display_name               = "nprd_int_lb"
    shape                      = var.lb_shape
    subnet_ids                 = var.subnet_ocid_lb  
    defined_tags               = local.tags
    is_private                 = true
    network_security_group_ids = var.nsg
}

############################################################################
# nprd - Internal LB Rule - SSL Header:
############################################################################

resource "oci_load_balancer_rule_set" "nprd_int_ssl_header" {
  items {
    action = "ADD_HTTP_REQUEST_HEADER"
    header = "WL-Proxy-SSL"
    value = "true"
  }
  load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
  name             = "nprd_int_ssl_header"
}

############################################################################
# nprd - Internal LB Rule - HTTPS Redirect:
############################################################################

resource "oci_load_balancer_rule_set" "nprd_int_https_redirect" {  
  load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
  name             = "nprd_int_https_redirect"
  items {
    action = "REDIRECT"
    redirect_uri {
      protocol = "HTTPS"
      host     = "{host}"
      port     = 443
      path     = "{path}"
    }
    conditions {
      attribute_name  = "PATH"
      attribute_value = "/"
      operator        = "PREFIX_MATCH"
    }
    response_code = 301
  }
}

############################################################################
# nprd - Internal LB Rule - invalid characters
############################################################################

resource "oci_load_balancer_rule_set" "nrpd_int_invalchars" {
  items {
    action = "HTTP_HEADER"
    are_invalid_characters_allowed  = "true"
  }
  load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
  name             = "nprd_int_invalidchar_header"
}

# ###########################################################################
# # nprd - Internal LB Wildcard Cert:
# ###########################################################################

resource "oci_load_balancer_certificate" "nprd_int_wildcard_cert" {
    certificate_name   = "nprd_int_wildcard_cert"
    load_balancer_id   = oci_load_balancer_load_balancer.nprd_int_lb.id
    passphrase         = "Gr34t!L3ighs"
    private_key        = var.private_key1
    public_certificate = var.public_certificate1
    ca_certificate     = var.ca_certificate1
    lifecycle {
        create_before_destroy = true
    }
}

resource "oci_load_balancer_certificate" "nprd_int_wildcard_cert_SAN" {
    certificate_name   = "nprd_int_wildcard_cert_SAN"
    load_balancer_id   = oci_load_balancer_load_balancer.nprd_int_lb.id
    passphrase         = "Gr34t!L3ighs"
    private_key        = var.private_key1
    public_certificate = var.public_certificate2
    ca_certificate     = var.ca_certificate1
}

############################################################################
# DEV :
############################################################################

resource "oci_load_balancer_hostname" "dev_int_ebs_hostname" {
    hostname         = "ebsdev.${var.customer_label}.police.uk"
    load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
    name             = "dev_int_ebs_hostname"
    lifecycle {
        create_before_destroy = true
    }
}

resource "oci_load_balancer_listener" "dev_int_ebs_http" {
  default_backend_set_name = oci_load_balancer_backend_set.dev_int_ebs_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.nprd_int_lb.id
  name                     = "dev_int_ebs_http"
  port                     = 80
  protocol                 = "HTTP"
  hostname_names           = [oci_load_balancer_hostname.dev_int_ebs_hostname.name] 
  rule_set_names           = [oci_load_balancer_rule_set.nprd_int_https_redirect.name
                             ]
  connection_configuration {
        idle_timeout_in_seconds = "1800"
  }
}

resource "oci_load_balancer_listener" "dev_int_ebs_https" {
  default_backend_set_name = oci_load_balancer_backend_set.dev_int_ebs_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.nprd_int_lb.id
  name                     = "dev_int_ebs_https"
  port                     = 443
  protocol                 = "HTTP"
  hostname_names           = [oci_load_balancer_hostname.dev_int_ebs_hostname.name] 
  rule_set_names           = [oci_load_balancer_rule_set.nprd_int_ssl_header.name]
  connection_configuration {
        idle_timeout_in_seconds = "1800"
  }
  ssl_configuration {
    certificate_name        = oci_load_balancer_certificate.nprd_int_wildcard_cert_SAN.certificate_name 
    verify_depth            = "1"
    verify_peer_certificate = false
  }
}

resource "oci_load_balancer_backend_set" "dev_int_ebs_backend_set" {
  health_checker {
    protocol  = "HTTP"
    port      = 8001
    retries   = 4
    url_path  = "/"
  }
  session_persistence_configuration {
    cookie_name = "ebs-dev-cookie"
  }
  load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
  name             = "dev_int_ebs_backend_set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "dev_int_ebs_backend" {
  backendset_name  = oci_load_balancer_backend_set.dev_int_ebs_backend_set.name
  ip_address       = local.ips.instances["devapp"]
  load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
  port             = 8001
}

############################################################################
# TST :
############################################################################

resource "oci_load_balancer_hostname" "tst_int_ebs_hostname" {
    hostname         = "ebstest.${var.customer_label}.police.uk"
    load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
    name             = "tst_int_ebs_hostname"
    lifecycle {
        create_before_destroy = true
    }
}

resource "oci_load_balancer_listener" "tst_int_ebs_http" {
  default_backend_set_name = oci_load_balancer_backend_set.tst_int_ebs_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.nprd_int_lb.id
  name                     = "tst_int_ebs_http"
  port                     = 80
  protocol                 = "HTTP"
  hostname_names           = [oci_load_balancer_hostname.tst_int_ebs_hostname.name] 
  rule_set_names           = [oci_load_balancer_rule_set.nprd_int_https_redirect.name
                             ]
  connection_configuration {
        idle_timeout_in_seconds = "1800"
  }
}

resource "oci_load_balancer_listener" "tst_int_ebs_https" {
  default_backend_set_name = oci_load_balancer_backend_set.tst_int_ebs_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.nprd_int_lb.id
  name                     = "tst_int_ebs_https"
  port                     = 443
  protocol                 = "HTTP"
  hostname_names           = [oci_load_balancer_hostname.tst_int_ebs_hostname.name] 
  rule_set_names           = [oci_load_balancer_rule_set.nprd_int_ssl_header.name]
  connection_configuration {
        idle_timeout_in_seconds = "1800"
  }
  ssl_configuration {
    certificate_name        = oci_load_balancer_certificate.nprd_int_wildcard_cert_SAN.certificate_name 
    verify_depth            = "1"
    verify_peer_certificate = false
  }
}

resource "oci_load_balancer_backend_set" "tst_int_ebs_backend_set" {
  health_checker {
    protocol  = "HTTP"
    port      = 8001
    retries   = 4
    url_path  = "/"
  }
  session_persistence_configuration {
    cookie_name = "ebs-test-cookie"
  }
  load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
  name             = "tst_int_ebs_backend_set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "tst_int_ebs_backend" {
  backendset_name  = oci_load_balancer_backend_set.tst_int_ebs_backend_set.name
  ip_address       = local.ips.instances["testapp"]
  load_balancer_id = oci_load_balancer_load_balancer.nprd_int_lb.id
  port             = 8001
}

