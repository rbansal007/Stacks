# Terraform Stack Configuration
# This stack deploys a basic AWS infrastructure with networking and compute components

required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}

provider "aws" "this" {
  config {
    region = var.region

    default_tags {
      tags = {
        ManagedBy   = "terraform-stacks"
        Environment = var.environment
        Stack       = "demo-stack"
      }
    }
  }
}

# Variables for the stack
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "stacks-demo"
}

# Component: Networking
# Creates VPC, subnets, internet gateway, and route tables
component "networking" {
  source = "./components/networking"

  providers = {
    aws = provider.aws.this
  }

  inputs = {
    region       = var.region
    environment  = var.environment
    project_name = var.project_name
  }
}

# Component: Compute
# Creates an EC2 instance in the networking component's subnet
component "compute" {
  source = "./components/compute"

  providers = {
    aws = provider.aws.this
  }

  inputs = {
    environment  = var.environment
    project_name = var.project_name
    vpc_id       = component.networking.vpc_id
    subnet_id    = component.networking.public_subnet_id
  }
}
