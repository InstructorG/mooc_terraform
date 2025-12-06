variable "list_of_files" {
  description = "List of buckets"

  type = list(string)

  default = ["file_first", "file_second", "file_third"]

  validation {
    condition = length(var.list_of_files) > 2 && alltrue([for v in var.list_of_files : (split("_", v)[0] == "file")])
    error_message = "Each file item should starting with \"file_\" and list should be more than 3"
  }
}



