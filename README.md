# Certificate Authority Terraform Module

Creates a certificate authority with a self-signed key, and signs one or more certificates.

```hcl-terraform
provider "tls" {}

module "uk_gov_ca" {
  source = "git@github.com:immutablecode/terraform-certificate-authority.git"

  ca_certificate_subject = {
    common_name    = "UK Government Root CA"
    organization   = "UK Government"
    street_address = ["10 Downing Street"]
    locality       = "Westminster"
    province       = "London"
    country        = "UK"
    postal_code    = "SW1A 2AA"
    serial_number  = 1
  }

  client_certificate_subjects = local.client_certificate_subjects
}

locals {
  client_certificate_subjects = [
    {
      common_name         = "mi5.gov.uk"
      alternative_names   = ["ss.gov.uk"]
      organization        = "UK Government"
      organizational_unit = "Intelligence"
      street_address      = ["Thames House", "12 Millbank"]
      locality            = "Westminster"
      province            = "London"
      country             = "UK"
      postal_code         = "SW1P 4QE"
      serial_number       = 5
    },
    {
      common_name         = "mi6.gov.uk"
      alternative_names   = ["sis.gov.uk"]
      organization        = "UK Government"
      organizational_unit = "Intelligence"
      street_address      = ["SIS Building", "85 Albert Embankment", "Vauxhall"]
      locality            = "Lambeth"
      province            = "London"
      country             = "UK"
      postal_code         = "SE11 5AW"
      serial_number       = 6
    }
  ]
  client_certificates = [for i in range(length(local.client_certificate_subjects)) : {
    name        = replace(local.client_certificate_subjects[i]["common_name"], "*", "all")
    certificate = module.uk_gov_ca.client_certificates[i]
    private_key = module.uk_gov_ca.client_private_keys[i]
  }]
}

resource "local_file" "ca_certificate" {
  content  = module.uk_gov_ca.ca_certificate
  filename = "gov.uk.crt"
}

resource "local_file" "ca_private_key" {
  content  = module.uk_gov_ca.ca_private_key
  filename = "gov.uk.key"
}

resource "local_file" "client_certificates" {
  count    = length(module.uk_gov_ca.client_certificates)
  content  = local.client_certificates[count.index].certificate
  filename = "${local.client_certificates[count.index].name}.crt"
}

resource "local_file" "client_private_keys" {
  count    = length(module.uk_gov_ca.client_private_keys)
  content  = local.client_certificates[count.index].private_key
  filename = "${local.client_certificates[count.index].name}.key"
}
```