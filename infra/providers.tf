provider "aws" {
  region  = var.region
  profile = "MY_NETWORKING"
  alias   = "MY_NETWORKING"
}

provider "aws" {
  region  = var.region
  profile = "MY_DEV_ENVIRONMENT"
  alias   = "MY_DEV_ENVIRONMENT"
}
