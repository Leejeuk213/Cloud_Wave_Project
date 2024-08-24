resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_info.cidr_block_vpc
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.common_info.env}-${var.vpc_info.vpc_name}"
  }
}