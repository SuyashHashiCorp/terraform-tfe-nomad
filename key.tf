# Generate a new EC2 Key Pair and store the key locally
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create EC2 Key Pair in AWS
resource "aws_key_pair" "tfe_nomad_key_pair" {
  key_name   = "tfe-nomad-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Store the private key PEM file locally
resource "local_file" "private_key_pem" {
  filename = "${path.module}/key_pair/tfe-nomad-key.pem"
  content  = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400"
}
