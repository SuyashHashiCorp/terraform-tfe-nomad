# Create VPC
resource "aws_vpc" "nomad_tfe_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "nomad-tfe-vpc"
  }
}


# Create a Public Subnet1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.nomad_tfe_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az_1 # Change this as needed

  tags = {
    Name = "public-subnet-1"
  }
}


# Create a Public Subnet2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.nomad_tfe_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az_2 # Change this as needed

  tags = {
    Name = "public-subnet-2"
  }
}


# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nomad_tfe_vpc.id

  tags = {
    Name = "my-internet-gateway"
  }
}


# Create a Route Table for the Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.nomad_tfe_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


# Associate Route Table with both Public Subnets
resource "aws_route_table_association" "public_route_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


# Create Security Group to allow all traffic from 0.0.0.0/0
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.nomad_tfe_vpc.id

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-all"
  }
}
