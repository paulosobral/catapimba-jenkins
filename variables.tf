# Security Group Module:

variable "vpc_name" {
  type = list(string)
}

variable "vpc_public_subnet" {
  type = list(string)
}

variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "ingress_rules" {
  type = list(string)
}

variable "egress_rules" {
  type = list(string)
}

# Instance Module:

variable "ami_name" {
  type = list(string)
}

variable "ami_owner" {
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

variable "docker_compose_instance_version" {
  type    = string
  default = "2.10.2"
}

variable "terraform_jenkins_version" {
  type    = string
  default = "1.2.8"
}