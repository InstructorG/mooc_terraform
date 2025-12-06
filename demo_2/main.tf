resource "aws_vpc" "exemple" {
  cidr_block = "160.0.0.0/16"

  provider = aws.demo
}