terraform {
  backend "s3" {
    bucket  = "navstatefiles"
    key     = "navstatefiles/tfstatefile/tfawsorg/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
    # dynamodb_table = "optional-dynamodb-lock-table-name"
  }
}

#s3 bucket textfile upload
resource "aws_s3_bucket_object" "s3textfile" {
  bucket = "navstatefiles"
  key    = "textfile.txt"
  source = "./textfile.txt"
  etag   = filemd5("./textfile.txt")
}