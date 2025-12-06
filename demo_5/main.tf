locals {
  # ...
}

resource "random_string" "random" {
  special = false
  length  = 10
  upper   = false
}

resource "aws_s3_bucket" "s3_atelier_3" {
  bucket        = "bucket-${random_string.random.result}"
  force_destroy = true
}

# local_file
#...


#S3 objects
#...