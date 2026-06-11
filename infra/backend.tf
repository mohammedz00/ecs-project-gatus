# Initialised S3 backend with native S3 state locking
terraform {
  backend "s3" {
    bucket = "zenudeen-gatus-state"
    key = "terraform.tfstate"
    region = "eu-west-1"
    use_lockfile = true
    
  }
}