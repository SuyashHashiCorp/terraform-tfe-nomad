# Terraform Enterprise Installation on Nomad Cluster

This repository contains Terraform configurations to deploy Terraform Enterprise (TFE) on a Nomad Cluster running on AWS EC2 instances. It sets up the necessary infrastructure including EC2 instances, RDS PostgreSQL, Redis, and S3 bucket, and configures TFE to run on a Nomad cluster.

## Prerequisites

Before using this setup, ensure you have the following prerequisites installed and configured on your local machine:

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or later)
- [Nomad](https://developer.hashicorp.com/nomad/install) (v1.5.0+ent or later)
- AWS account with sufficient permissions to create and manage resources (EC2, RDS, S3, Redis, etc.
- AWS CLI configured on your local machine (or set up environment variables for AWS credentials)
  
## Getting Started

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/your-repository/terraform-tfe-nomad.git
cd terraform-tfe-nomad
```

### 2. Update the `variables.tf` File

You need to provide values for several variables in the variables.tf file. Open `variables.tf` and adjust the following:

- `aws_region`    - Specify your preferred AWS region.
- `ami_id`        - Provide the AMI ID for the EC2 instances.
- `az_*`          - Set the Availability Zones for your Subnets (az_1, az_2).
- `tfe_license`   - Insert your TFE license here.
- `tfe_encryption_password` - Insert the password which you want to use for Internal Vault.
- `db_*`          - Update database-related variables (db_name, db_username, db_password).
- `domain_name`   - Provide the domain name you will use for TFE.

**Note:** Additional customization might be required depending on your environment.

### 3. Update the Nomad License in the `scripts/tfe_nomad_server_data.sh` file at line 73.
As TFE is going to be installed in a custom namespace at the Nomad level, and `namespaces` are an Enterprise feature in Nomad, you will need a valid Nomad Enterprise license to proceed.

### 3. Initialize Terraform

Initialize Terraform in your local environment to download the necessary providers and modules:

```bash
terraform init
```

### 4. Plan and Apply

After initialization, you can run Terraform plan to check what will be created:

```bash
terraform plan
```

To apply the changes and provision the resources, run:

```bash
terraform apply
```

This command will prompt for confirmation. Enter yes to proceed.


## Components Provisioned

This Terraform configuration will provision the following components on AWS:

- EC2 instances for running TFE on Nomad
- RDS PostgreSQL instance for TFE backend
- Redis for caching
- S3 bucket for object storage
- Necessary security groups, IAM roles, and instance profiles
- DNS records for TFE Hostname via Route53
- Nomad job to deploy Terraform Enterprise


## How to Use

### 1. Access the EC2 Instances

Once the resources are provisioned, SSH into the EC2 instances using the private key generated (key_pair/tfe-nomad-key.pem):

```bash
ssh -i key_pair/tfe-nomad-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### 2. Access Terraform Enterprise UI

The TFE application will be accessible via the domain you specified in `var.domain_name` at:

```bash
https://tfe-nomad.<your_domain>
```
You can log in and start using Terraform Enterprise once the setup is complete.


## Outputs

Once Terraform completes the deployment, you will get several useful output values:

- `ec2_public_ips_with_tags`: List of EC2 instances with their public IPs and tags.
- `db_connection_url`: Connection URL for the PostgreSQL database.
- `s3_bucket_name`: S3 bucket name used for object storage.
- `redis_endpoint`: Redis cache endpoint and port.
- `route53_record`: FQDN of the Route 53 DNS record for TFE.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
