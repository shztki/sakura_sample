module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = module.label.id

  ami           = data.aws_ami.amazon2_arm.id
  instance_type = "t4g.nano"
  subnet_id     = module.vpc.public_subnets[0]

  vpc_security_group_ids = [module.allow_office_sg.security_group_id]

  key_name = module.label.id

  associate_public_ip_address = true

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 10
    }
  ]

  volume_tags = merge(
    module.label.tags,
    tomap({ Name = module.label.id }),
  )

  tags = merge(
    module.label.tags,
    tomap({ Name = module.label.id }),
  )

  ignore_ami_changes = true
}
