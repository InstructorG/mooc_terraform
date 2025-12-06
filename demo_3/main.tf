resource "local_file" "first_file" {
  content = "THIS IS A TEST"
  filename = "file_1.txt"
}


resource "local_file" "second_file" {
  content = "THIS IS A TEST"
  filename = "./directory/file_2.txt"
}