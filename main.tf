terraform {
  backend "s3" {
    bucket  = "navstatefiles"
    key     = "navstatefiles/tfstatefile/tfawsorg/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
    # dynamodb_table = "optional-dynamodb-lock-table-name"
  }
}