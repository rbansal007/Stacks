# Terraform Stacks Demo

This repository contains a Terraform Stack configuration for testing the **Stacks** feature in Terraform Enterprise 2.0.

## Requirements

- Terraform Enterprise 2.0+ with Stacks feature enabled (`access-beta-tools: true`)
- Terraform version **1.13.0+** (required for Stacks support)
- AWS IAM permissions on the TFE instance role (or explicit `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` env vars set on the stack)

## Structure

```
.
├── components.tfcomponent.hcl      # Stack definition (components & dependencies)
├── deployments.tfdeploy.hcl        # Deployment definitions (dev, staging)
├── .terraform-version              # Pins Terraform to 1.13.0
├── .terraform.lock.hcl             # Provider lock file (linux_amd64 + darwin_arm64)
├── components/
│   ├── networking/                 # Networking component
│   │   ├── main.tf                # VPC, subnets, IGW, route tables, security groups
│   │   ├── variables.tf           # Input variables
│   │   └── outputs.tf             # Outputs consumed by compute component
│   └── compute/                   # Compute component
│       ├── main.tf                # EC2 instance with web server
│       ├── variables.tf           # Input variables (includes networking outputs)
│       └── outputs.tf             # Instance details
```

> **Note on file naming:** TFE 2.0 requires strict file naming conventions:
> - Stack definition file must use the `.tfcomponent.hcl` extension (e.g. `components.tfcomponent.hcl`)
> - Deployments file must use the `.tfdeploy.hcl` extension (e.g. `deployments.tfdeploy.hcl`)

## Components

### Networking
- VPC with DNS support
- Public subnet (with auto-assign public IP)
- Private subnet
- Internet Gateway
- Route table with internet access
- Security group (SSH + HTTP)

### Compute (depends on Networking)
- EC2 instance (Amazon Linux 2023, t3.micro)
- Deployed into the networking component's public subnet
- Simple Apache web server via user_data

## Deployments

| Deployment | Region     | Environment |
|-----------|------------|-------------|
| dev       | us-east-1  | dev         |
| staging   | us-west-2  | staging     |

## Usage

1. Connect this repo as a VCS provider in TFE
2. Create a new **Stack** in your TFE organization
3. Point it to this repository
4. Ensure the TFE instance IAM role has EC2 permissions (or set `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` as sensitive environment variables on the stack)
5. TFE will detect `components.tfcomponent.hcl` and `deployments.tfdeploy.hcl`
6. Deployments (`dev` and `staging`) will appear in the Deployments tab
7. Trigger a plan/apply per deployment

## Lock File

The `.terraform.lock.hcl` was generated with cross-platform support:
```
terraform providers lock -platform=linux_amd64 -platform=darwin_arm64
```
This is required because TFE runs on `linux_amd64` while local development may be on macOS (`darwin_arm64`).
6. Review the coordinated plan across both components
7. Apply — networking deploys first, then compute
