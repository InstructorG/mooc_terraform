resource "random_string" "random" {
  special = false
  length = 10
  upper = false
}


#TODO : IMPORT KMS alias/student-main-key
# ...


#TODO : CREATE BUCKET S3 WITH FORCE DESTROY AND RANDOM SUFFIX
# ...



#TODO : ENCRYPT BUCKET WITH IMPORTED KMS
#...