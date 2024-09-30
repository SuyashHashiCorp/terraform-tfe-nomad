# Terraform Enterprise Installation on Nomad Cluster

This repository contains Terraform configurations to deploy Terraform Enterprise (TFE) on a Nomad Cluster running on AWS EC2 instances. It sets up the necessary infrastructure including EC2 instances, RDS PostgreSQL, Redis, and S3 bucket, and configures TFE to run on a Nomad cluster.

## Prerequisites

Before using this setup, ensure you have the following prerequisites installed and configured on your local machine:

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or later)
- AWS account with sufficient permissions to create and manage resources (EC2, RDS, S3, Redis, etc.)
- Nomad Cluster with the appropriate permissions for deploying workloads.
- AWS CLI configured on your local machine (or set up environment variables for AWS credentials)
  
## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-repository/terraform-tfe-nomad.git
cd terraform-tfe-nomad
