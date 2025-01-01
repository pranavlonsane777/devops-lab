provider "aws" {
  region = "ap-south-1"
}
provider "helm" {
    kubernetes {
       config_path = "~/.kube/config"
    }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}