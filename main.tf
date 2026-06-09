terraform {
  backend "s3" {
    bucket       = "terraform-state-task-3-2-4"
    key          = "github-terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
resource "aws_key_pair" "deploy" {
  key_name   = "github-deploy-key"
  public_key = file("${path.root}/github-deploy-key.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  aws_region         = "us-east-1"
  environment        = "dev"
}

module "ec2" {
  source        = "./modules/ec2"
  depends_on    = [module.vpc]
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_id
  allocate_eip  = true

  instance_name = "dev-web-server"
  user_data_script = templatefile("${path.root}/setup.sh", {
    certbot_email = var.certbot_email
  })
  vpc_id = module.vpc.vpc_id

  key_name = aws_key_pair.deploy.key_name
}

module "route53" {
  source      = "./modules/route53"
  domain_name = "fox-tier-task.pp.ua"
  record_name = "task-3-2-4.fox-tier-task.pp.ua"
  target_ip   = module.ec2.eip_public_ip
} 