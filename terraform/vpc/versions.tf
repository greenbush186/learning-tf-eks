terraform {
    required_version = "~> 1.8"
    required_providers {
      aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
      }
    }
    backend "s3" { # passed via -backend-config on terraform init command line
    }
}

provider "aws" {
    region = "ap-southeast-2"
    profile = "default"
}
