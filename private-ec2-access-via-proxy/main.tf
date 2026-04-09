module "vpc" {
  source   = "../modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_eip         = var.enable_eip

  anywhere_cidr     = var.anywhere_cidr
  app_ingress_rules = var.app_ingress_rules
  db_port           = var.db_port


}
module "proxy_ec2" {
  source = "../modules/ec2"

  name_prefix    = "proxy"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnet_ids[0]
  instance_type  = "t3.micro"
  ami_id         = var.ec2_ami_id
  key_name       = var.ec2_key_name
  my_ip_cidr     = var.my_ip_cidr
  user_data_file = "./squid.sh"

  associate_public_ip = true
  create_ssm_role     = true
}

module "private_app_ec2" {
  source = "../modules/ec2"

  name_prefix    = "private-nginx"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.private_subnet_ids[0]
  instance_type  = "t3.micro"
  ami_id         = var.ec2_ami_id
  key_name       = var.ec2_key_name
  my_ip_cidr     = var.my_ip_cidr
  user_data_file = "./nginx_script.sh"

  associate_public_ip = false
  create_ssm_role     = true
}
