provider "aws" {
  region = "ca-central-1"
}

terraform {
  backend "s3" {
    bucket         = "max-supru-step-project-3.1"
    key            = "max-supru/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true
  }
}