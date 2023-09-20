data "aws_vpc" "default_vpc" {
  default = true
}

data "http" "myip" {
  url = "http://ifconfig.me"
}