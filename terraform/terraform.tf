terraform {
  required_providers {
    local = {
      version = "~> 2"
      source  = "hashicorp/local"
    }
    aws = {
      version = "~> 5"
      source  = "hashicorp/aws"
    }
    tls = {
      version = "~> 4"
      source  = "hashicorp/tls"
    }
    http = {
      version = "~> 3"
      source  = "hashicorp/http"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
}