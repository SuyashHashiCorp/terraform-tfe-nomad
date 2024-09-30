provider "aws" {
  profile                  = "default"
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }

   # Nomad provider for deploying Nomad related resources
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.2.0"
    }
  }
  required_version = ">= 0.14.9"
}

# TLS provider for generating certificates and keys
provider "tls" {}
