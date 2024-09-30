#Public IP of the EC2 Instance
output "ec2_public_ips_with_tags" {
  value = [
    for instance in aws_instance.instance :
    "${instance.tags["Name"]}: ${instance.public_ip}"
  ]
  description = "List of EC2 instances with their public IPs and Name tags"
}


#PostgresDB Details
# Outputs for the DB connection details
output "db_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

output "db_connection_url" {
  value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.postgres_db.endpoint}/${var.db_name}"
}


# Output the S3 bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.tfe_nomad_s3_bucket.bucket
}


# Output the Redis cluster connection details
output "redis_endpoint" {
  value       = aws_elasticache_cluster.redis_cache.cache_nodes[0].address
  description = "Redis cache endpoint"
}

output "redis_port" {
  value       = aws_elasticache_cluster.redis_cache.port
  description = "Redis cache port"
}

output "redis_engine_version" {
  value       = aws_elasticache_cluster.redis_cache.engine_version
  description = "Redis cache engine version"
}


# Output the DNS record created
output "route53_record" {
  value       = aws_route53_record.nomad_client_public_a_record.fqdn
  description = "FQDN of the Route 53 record"
}
