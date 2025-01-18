
terraform {
  backend "s3" {
    bucket         = "terraform-state-danit-devops5"
    key            = "max-supru/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}