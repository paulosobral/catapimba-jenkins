# Security Group Module:

data "aws_vpc" "catapimba_vpc" {
  filter {
    name   = "tag:Name"
    values = var.vpc_name
  }
}

data "aws_subnet" "catapimba_public_subnet" {
  filter {
    name   = "cidr-block"
    values = var.vpc_public_subnet
  }
}

# Instance Module:

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = var.ami_name
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = var.ami_owner
}

data "template_file" "user_data_file" {
  template = file("${path.module}/user_data.sh")
  vars = {
    docker_compose_instance_version = "${var.docker_compose_instance_version}"
    terraform_jenkins_version       = "${var.terraform_jenkins_version}"
  }
}