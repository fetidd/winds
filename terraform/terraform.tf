locals {
  region = "eu-west-2"
  lambda_runtime = "python3.12"
}

provider "aws" {
  region = local.region
}  

