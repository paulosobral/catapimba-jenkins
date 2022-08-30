variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "ingress_rules" {
  type = list(string)
}

variable "egress_rules" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "monitoring" {
  type = bool
}

variable "iam_instance_profile" {
  type = string
}