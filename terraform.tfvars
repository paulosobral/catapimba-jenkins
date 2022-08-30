ingress_cidr_blocks = ["0.0.0.0/0"]
ingress_rules       = ["http-80-tcp", "ssh-tcp"]
egress_rules        = ["all-all"]

instance_type        = "t3.micro"
key_name             = "vockey"
monitoring           = true
iam_instance_profile = "LabInstanceProfile"