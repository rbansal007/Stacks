# Terraform Stacks Demo

This repository contains a Terraform Stack configuration for testing the **Stacks** feature in Terraform Enterprise 2.0.

## Structure

```
.
├── tfstacks.hcl                    # Stack definition (components & dependencies)
├── tfdeploy.hcl                    # Deployment definitions (dev, staging)
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
4. TFE will detect `tfstacks.hcl` and `tfdeploy.hcl`
5. Select a deployment (dev/staging) and trigger a plan
6. Review the coordinated plan across both components
7. Apply — networking deploys first, then compute
