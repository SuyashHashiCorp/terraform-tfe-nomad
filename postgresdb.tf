# Create RDS PostgreSQL Database Instance
resource "aws_db_instance" "postgres_db" {
  identifier             = var.db_identifier_name
  allocated_storage      = 50
  engine                 = "postgres"
  engine_version         = var.postgres_db_version
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.public_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  skip_final_snapshot = true

  tags = {
    Name = "Postgres-DB-TFE-Nomad"
  }

}

# Create a DB Subnet Group for the RDS instance
resource "aws_db_subnet_group" "public_subnet_group" {
  name       = "public-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] # Ensure different AZs

  tags = {
    Name = "RDS Subnet Group"
  }
}
