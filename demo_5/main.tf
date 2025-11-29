locals {
  files_names = {
    for key, value in var.list_of_files : value => "${value}-${random_string.random.result}"
  }
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

resource "local_file" "file" {
  for_each = local.files_names
  filename = each.key
  content  = each.value
}

resource "aws_s3_object" "example" {
  count = length(var.list_of_files)

  bucket = aws_s3_bucket.s3_atelier_3.id
  key    = "${local_file.file[var.list_of_files[count.index]].filename}-object"
  source = local_file.file[var.list_of_files[count.index]].filename
}