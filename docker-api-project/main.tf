provider "aws" {
  # Configuration options
  region = "us-east-1"
  # access_key
  # secret_access_key
  # or IAM role if working on an EC2
}

provider "github" {
  # Configuration options
  token = var.github_token
}

resource "github_repository" "bookstoreapi" {
  name       = "bookstoreapi"
  visibility = "private"
  auto_init  = true
}

resource "github_branch_default" "main" {
  branch     = "main"
  repository = github_repository.bookstoreapi.name
}

resource "github_repository_file" "app-files" {
  repository          = github_repository.bookstoreapi.name
  branch              = "main"
  for_each            = toset(var.repo-files)
  content             = file(each.value)
  file                = each.value
  commit_message      = "created via TF"
  commit_author       = "Fatih GUMUS" # a specified name
  commit_email        = "fatihgumush@gmail.com" # an e-mail address
  overwrite_on_create = true
}

