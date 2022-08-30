# Security Group Module:

vpc_name            = ["catapimba-corps-vpc"]
vpc_public_subnet   = ["10.0.101.0/24"]
ingress_cidr_blocks = ["0.0.0.0/0"]
ingress_rules       = ["http-80-tcp", "ssh-tcp"]
egress_rules        = ["all-all"]

# Instance Module:

ami_name             = ["amzn-ami-hvm-*-x86_64-gp2"]
ami_owner            = ["amazon"]
instance_type        = "t3.micro"
key_name             = "vockey"
monitoring           = true
iam_instance_profile = "LabInstanceProfile"