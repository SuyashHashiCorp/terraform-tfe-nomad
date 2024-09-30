#AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "ap-south-1"
}


#EC2
variable "ami_id" {
  default = "ami-0f58b397bc5c1f2e8"
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
  default = "ap-south-1a"
}

variable "az_2" {
  description = "Availability-Zone-2 for Subnet_2"
  default = "ap-south-1b"
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
  default     = "tfenomaddb1"
}

variable "db_username" {
  description = "Username for the PostgreSQL database"
  default     = "tfenomaddbadmin"
}

variable "db_password" {
  description = "Password for the PostgreSQL database"
  default     = "tfenomaddb123"
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
  default     = "Z029268935HORWYTMTX0C" # Update with your hosted zone ID
}

variable "domain_name" {
  description = "The domain name for the Route 53 record"
  type        = string
  default     = "nomad-support.hashicorpdemo.com" # Replace with your domain name
}


#TFE Nomad Variables
variable "tfe_license" {
  description = "TFE License"
  type        = string
  default     = "02MV4UU43BK5HGYYTOJZWFQMTMNNEWU33JJ5KGQ22PI5KTGWSUKF2E46SRPJHUGMBULJKECNKMKRGTCWTKJV2FU3KRGBNFISTMJ5KES6C2NJRTASLJO5UVSM2WPJSEOOLULJMEUZTBK5IWST3JJEYE2R2JPFHEIUL2LJJTC3CONVLG2TCUJJUVU3KJORHDERTMJZBTANKNNVGXST2UNM2VU2SVGRHG2ULJJRBUU4DCNZHDAWKXPBZVSWCSOBRDENLGMFLVC2KPNFEXCSLJO5UWCWCOPJSFOVTGMRDWY5C2KNETMSLKJF3U22SRORGUIWLUJVKGQVKNIRGTMTL2JU3E22SBOVGVISJRJV5FC6KNPJVXQV3JJFZUS3SOGBMVQSRQLAZVE4DCK5KWST3JJF4U2RCJGBGFIQJSJRKEKNCWIRAXOT3KIF3U62SBO5LWSSLTJFWVMNDDI5WHSWKYKJYGEMRVMZSEO3DULJJUSNSJNJEXOTLKNN2E2RCZORGVI2CVJVCECNSNIRATMTKEIJQUS2LXNFSEOVTZMJLWY5KZLBJHAYRSGVTGIR3MORNFGSJWJFVES52NNJVXITKELF2E2VDIKVGUIQJWJVCECNSNIRBGCSLJO5UWGSCKOZNEQVTKMRBUSNSJNZJGYY3OJJUFU3JZPFRFGSLTJFWVU42ZK5SHUSLKOA3WMWBQHUXHSMDNIV3FCVD2MRJVE5LSONGHO43IKFZWI4KZKVVTIRSMIJ5E2NLUM4ZXAK2ZKVEWCWLFIFJE4U22OBVEU3TMGM2TI3KRFNXFIOBPMVYDIUSSJFYXUN3IMQ4GG52MNBJTMSKPNVCEUMLEIFVWGYJUMRLDAMZTHBIHO3KWNRQXMSSQGRYEU6CJJE4UINSVIZGFKYKWKBVGWV2KORRUINTQMFWDM32PMZDW4SZSPJIEWSSSNVDUQVRTMVNHO4KGMUVW6N3LF5ZSWQKUJZUFAWTHKMXUWVSZM4XUWK3MI5IHOTBXNJBHQSJXI5HWC2ZWKVQWSYKIN5SWWMCSKRXTOMSEKE6T2"
}

variable "tfe_image" {
  description = "TFE Release"
  default     = "images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202409-1"
}
