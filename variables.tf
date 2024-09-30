#AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = " "  # Update your AWS Region
}


#EC2
variable "ami_id" {
  default = " "  # Update with your AMI ID 
}

variable "instance_type" {
  default = "t3.2xlarge"
}

variable "volume_size" {
  type    = number
  default = 100
}

variable "instance_name" {
  type    = list(string)
  default = ["TFE-Nomad-Server", "TFE-Nomad-Client"]
}

variable "private_ip" {
  type    = list(any)
  default = ["10.0.1.101", "10.0.1.102"]
}

variable "instance_count" {
  type    = number
  default = 2
}


#UserScripts
variable "userscripts" {
  type    = list(any)
  default = ["tfe_nomad_server_data.sh", "tfe_nomad_client_data.sh"]
}


#VPC & Subnet
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.2.0/24"
}

variable "az_1" {
  description = "Availability-Zone-1 for Subnet_1"
  default = " "  # Update with your Availability Zone_1
}

variable "az_2" {
  description = "Availability-Zone-2 for Subnet_2"
  default = " "  # Update with your Availability Zone_2
}


#PostgresDB Variables
variable "db_identifier_name" {
  description = "Postgres DB Identifier Name"
  default     = "tfenomaddb"
}

variable "postgres_db_version" {
  description = "Version of the Postgres DB"
  default     = "15.8"
}

variable "db_name" {
  description = "Name of the PostgreSQL database"
  default     = " "  # Update with your PostgresDB Instance Name
}

variable "db_username" {
  description = "Username for the PostgreSQL database"
  default     = " "  # Update with your PostgresDB Username
}

variable "db_password" {
  description = "Password for the PostgreSQL database"
  default     = " "  # Update with your PostgresDB Password
}


#S3 Bucket Variable
variable "s3_bucket_name" {
  description = "S3 Bucket Name for TFE cluster on Nomad"
  default     = "tfe-nomad-s3-bucket"
}


#Redis Variable
variable "redis_engine_version" {
  description = "Redis Cache Enginer Version"
  default     = "6.2"
}


# Replace with your hosted zone ID and domain name
variable "hosted_zone_id" {
  description = "The ID of the Route 53 Hosted Zone"
  type        = string
  default     = " "  # Update with your Hosted Zone ID
}

variable "domain_name" {
  description = "The domain name for the Route 53 record"
  type        = string
  default     = " "  # Update with your domain name
}


#TFE Nomad Variables
variable "tfe_license" {
  description = "TFE License"
  type        = string
  default     = " "  # Update with your TFE License
}

variable "tfe_image" {
  description = "TFE Release"
  default     = "images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202409-1"  # Replace with the TFE Release Image
}

variable "tfe_encryption_password" {
  description = "Encryption password for Internal Vault Mode"
  default     = " "  # Update with the Encryption Password
}
