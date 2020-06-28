resource "tls_private_key" "root" {
  algorithm   = "RSA"
  rsa_bits    = var.ca_key_rsa_bits
}

resource "tls_self_signed_cert" "root" {
  key_algorithm         = tls_private_key.root.algorithm
  private_key_pem       = tls_private_key.root.private_key_pem
  validity_period_hours = var.ca_certificate_validity_period_hours
  early_renewal_hours   = var.ca_certificate_early_renewal_hours
  is_ca_certificate     = true
  allowed_uses          = ["cert_signing"]
  subject {
    common_name         = lookup(var.ca_certificate_subject, "common_name", null)
    country             = lookup(var.ca_certificate_subject, "country", null)
    locality            = lookup(var.ca_certificate_subject, "locality", null)
    organization        = lookup(var.ca_certificate_subject, "organization", null)
    organizational_unit = lookup(var.ca_certificate_subject, "organizational_unit", null)
    postal_code         = lookup(var.ca_certificate_subject, "postal_code", null)
    province            = lookup(var.ca_certificate_subject, "province", null)
    serial_number       = lookup(var.ca_certificate_subject, "serial_number", null)
    street_address      = lookup(var.ca_certificate_subject, "street_address", null)
  }
}

resource "tls_private_key" "client" {
  count       = length(var.client_certificate_subjects)
  algorithm   = "RSA"
  rsa_bits    = var.client_key_rsa_bits
}

resource "tls_cert_request" "client" {
  count           = length(var.client_certificate_subjects)
  key_algorithm   = tls_private_key.client[count.index].algorithm
  private_key_pem = tls_private_key.client[count.index].private_key_pem
  dns_names       = lookup(var.client_certificate_subjects[count.index], "dns_names", null)
  ip_addresses    = lookup(var.client_certificate_subjects[count.index], "ip_addresses", null)
  uris            = lookup(var.client_certificate_subjects[count.index], "uris", null)
  subject {
    common_name         = lookup(var.client_certificate_subjects[count.index], "common_name", null)
    country             = lookup(var.client_certificate_subjects[count.index], "country", null)
    locality            = lookup(var.client_certificate_subjects[count.index], "locality", null)
    organization        = lookup(var.client_certificate_subjects[count.index], "organization", null)
    organizational_unit = lookup(var.client_certificate_subjects[count.index], "organizational_unit", null)
    postal_code         = lookup(var.client_certificate_subjects[count.index], "postal_code", null)
    province            = lookup(var.client_certificate_subjects[count.index], "province", null)
    serial_number       = lookup(var.client_certificate_subjects[count.index], "serial_number", null)
    street_address      = lookup(var.client_certificate_subjects[count.index], "street_address", null)
  }
}

resource "tls_locally_signed_cert" "client" {
  count                 = length(var.client_certificate_subjects)
  cert_request_pem      = tls_cert_request.client[count.index].cert_request_pem

  ca_key_algorithm      = tls_private_key.root.algorithm
  ca_private_key_pem    = tls_private_key.root.private_key_pem

  ca_cert_pem           = tls_self_signed_cert.root.cert_pem 

  validity_period_hours = var.client_certificate_validity_period_hours
  early_renewal_hours   = var.client_certificate_early_renewal_hours

  allowed_uses = [
    "server_auth",
    "client_auth"
  ]
}
