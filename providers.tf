terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.12.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.2"
    }
  }
  // store tfstate file in s3 bucket
  backend "s3" {
    bucket = "fc-terraform-tx"
    key = "terraform.tfstate"
    region = "us-east-1"
    profile = "demo"
  }
}

provider "local" {
  # Configuration options
}
provider "aws" {
  region = "us-east-1"
  profile = "demo"   # profile name ~/aws/credencials

}