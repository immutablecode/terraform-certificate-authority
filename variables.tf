variable "ca_key_rsa_bits" {
  type    = number
  default = 2048
}

variable "ca_certificate_subject" {
}

variable "ca_certificate_validity_period_hours" {
  type    = number
  default = 26280
}

variable "ca_certificate_early_renewal_hours" {
  type    = number
  default = 8760
}

variable "client_key_rsa_bits" {
  type    = number
  default = 2048
}

variable "client_certificate_subjects" {
}

variable "client_certificate_validity_period_hours" {
  type    = number
  default = 17520
}

variable "client_certificate_early_renewal_hours" {
  type    = number
  default = 8760
}
