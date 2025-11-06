variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "my_ip" {
  type    = string
  default = "186.11.14.10/32"
}

variable "db_username" {
  type      = string
  default   = "admin"
  sensitive = true
}

variable "db_password" {
  type      = string
  default   = "ClaveSegura12345"
  sensitive = true
}