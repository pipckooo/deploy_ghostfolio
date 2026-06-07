terraform {
  required_version = "1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.48.0"
    }
  }
}
data "aws_route53_zone" "my_domain" {
  name         = var.domain_name
  private_zone = false
}


resource "aws_route53_record" "task_record" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = var.record_name
  type    = "A"
  ttl     = 300
  records = [var.target_ip]
}