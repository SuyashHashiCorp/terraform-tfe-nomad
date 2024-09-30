# Create a Redis cluster (ElastiCache) in the same VPC, subnets, and security group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] # Assuming two public subnets

  tags = {
    Name = "redis-subnet-group"
  }
}

# Create Redis ElastiCache instance
resource "aws_elasticache_cluster" "redis_cache" {
  cluster_id           = "tfe-nomad-redis-cache"
  engine               = "redis"
  engine_version       = var.redis_engine_version
  node_type            = "cache.t3.micro" # Modify as needed for production workloads
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.allow_all.id]
  port                 = 6379
  parameter_group_name = "default.redis6.x"

  tags = {
    Name = "tfe-nomad-redis-cache"
  }
}
