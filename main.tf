

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  aws_region         = "us-east-1"
  environment        = "dev"
}

module "ec2" {
  source        = "./modules/ec2"
  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_id
  allocate_eip  = true

  instance_name = "dev-web-server"
  user_data_script = templatefile("${path.root}/setup.sh", {
    certbot_email = var.certbot_email
  })
  vpc_id   = module.vpc.vpc_id
  my_ip    = var.my_ip
  key_name = aws_key_pair.deploy.key_name
}

module "route53" {
  source      = "./modules/route53"
  domain_name = "fox-tier-task.pp.ua"
  record_name = "task-3-2-4.fox-tier-task.pp.ua"
  target_ip   = module.ec2.eip_public_ip
} 