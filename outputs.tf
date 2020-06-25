output "ca_certificate" {
  value = tls_self_signed_cert.root.cert_pem
}

output "ca_private_key" {
  value = tls_private_key.root.private_key_pem
}

output "client_certificates" {
  value = tls_locally_signed_cert.client.*.cert_pem
}

output "client_private_keys" {
  value = tls_private_key.client.*.private_key_pem
}
