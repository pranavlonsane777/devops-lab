terraform {
  backend "s3" {
    bucket = "my-app-state"
    key    = "my-app/terraform.tfstate"
    region = "ap-south-1"
  }
}
