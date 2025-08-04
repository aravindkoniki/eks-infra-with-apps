provider "aws" {
  region  = "eu-central-1"
  profile = "MY_NETWORKING"
  alias   = "MY_NETWORKING"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "MY_DEV_ENVIRONMENT"
  alias   = "MY_DEV_ENVIRONMENT"
}
