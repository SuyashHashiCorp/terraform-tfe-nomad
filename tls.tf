# Generate a private RSA key (4096 bits)
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a self-signed X509 certificate
resource "tls_self_signed_cert" "self_signed_cert" {
  subject {
    common_name         = aws_route53_record.nomad_client_public_a_record.fqdn # Common Name (CN)
    organization        = "HashiCorp"                                          # Organization Name
    organizational_unit = "HC"                                                 # Organizational Unit
  }

  validity_period_hours = 30 * 24 # 1 Month validity (30 days)

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]

  private_key_pem = tls_private_key.private_key.private_key_pem

  depends_on = [aws_route53_record.nomad_client_public_a_record]
}

# Output the private key and certificate to files
resource "local_file" "private_key_file" {
  filename = "${path.module}/certs/key.pem"
  content  = tls_private_key.private_key.private_key_pem
}

resource "local_file" "certificate_file" {
  filename = "${path.module}/certs/cert.pem"
  content  = tls_self_signed_cert.self_signed_cert.cert_pem
}
