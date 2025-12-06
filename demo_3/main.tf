resource local_file "file_1" {
  content = "THIS IS FILE 1"
  filename = "file_1.txt"
}

resource "local_file" "file_2" {
  filename = "directory/file_2.txt"
  content = "THIS IS FILE 2"
}