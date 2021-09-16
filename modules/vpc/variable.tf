variable "project" {}
variable "env" {}
variable "cidr_block" {}
variable "public_subnets" {
  type    = map(string)
  default = {}
}
variable "private_subnets" {
  type    = map(string)
  default = {}
}