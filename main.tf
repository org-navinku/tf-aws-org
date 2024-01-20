terraform {
  backend "s3" {
    bucket  = "navstatefiles"
    key     = "navstatefiles/tfstatefile/tfawsorg/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
    # dynamodb_table = "optional-dynamodb-lock-table-name"
  }
}

# variable "force_upload" {
#   description = "Set to true to force upload the file"
#   type        = bool
#   default     = false
# }

# #s3 bucket textfile upload
# resource "aws_s3_bucket_object" "s3textfile" {
#   bucket = "navstatefiles"
#   key    = "textfile.txt"
#   source = "./textfile.txt"

#   # Use lifecycle block to force new resource if there are changes
#   lifecycle {
#     create_before_destroy = true
#   }

#   # Only set etag attribute if force_upload is true
#   etag = var.force_upload ? "" : md5(file("./textfile.txt"))
# }