terraform {
  backend "s3" {
    bucket = "blue-cat"
    key    = "state-file/terraform.tf"
    region = "ap-northeast-1"
  }
}
