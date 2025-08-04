module "vpc" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source = "./vpc"
  name   = var.name
  region = var.region
}
