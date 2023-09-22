terraform {
  cloud {
    organization = "ag-techs"

    workspaces {
      name = "bookstoreapi"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
