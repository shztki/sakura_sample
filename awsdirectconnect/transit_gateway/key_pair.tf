resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = module.label.id
  public_key = trimspace(tls_private_key.this.public_key_openssh)

  tags = merge(
    module.label.tags,
    tomap({ Name = module.label.id }),
  )
}
