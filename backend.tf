terraform {
  backend "s3" {
    bucket = "terraform-state-psobral89"
    key    = "terraform-jenkins-catapimba.tfstate"
    region = "us-east-1"
  }
}