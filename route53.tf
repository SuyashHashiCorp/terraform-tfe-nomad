# Create an A record in Route 53 for the EC2 instance's public IP
resource "aws_route53_record" "nomad_client_public_a_record" {
  zone_id = var.hosted_zone_id
  name    = "tfe-nomad.${var.domain_name}" # Creates ec2.example.com

  type = "A"
  ttl  = 300 # Time to live for DNS record

  records = [aws_instance.instance[1].public_ip] # Use the EC2 instance's public IP
}
