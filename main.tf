terraform {
  backend "s3" {
    bucket  = "bucketname"
    key     = "bucket/path/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
    # dynamodb_table = "optional-dynamodb-lock-table-name"
  }
}