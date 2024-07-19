provider "aws" {
  region                    = "us-east-1"
  profile                   = "kloud"
  shared_credentials_files  = ["~/.aws/credentials"]
}