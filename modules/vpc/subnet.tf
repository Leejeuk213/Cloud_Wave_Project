resource "aws_subnet" "subnets_public" {
  for_each = var.vpc_info.cidr_blocks_public

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "${var.common_info.env}-${each.value.subnet_name}"
      "kubernetes.io/role/elb"              = 1
    }
  )
}

resource "aws_subnet" "subnets_private" {
  for_each = var.vpc_info.cidr_blocks_private

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(
    {
      Name = "${var.common_info.env}-${each.value.subnet_name}"
      "karpenter.sh/discovery" = var.eks_cluster_info.cluster_name
      "kubernetes.io/role/internal-elb"     = 1
    }
  )
}

#resource "aws_subnet" "subnets_private_db" {
#  for_each = var.vpc_info.cidr_blocks_private_db

#  vpc_id     = aws_vpc.vpc.id
#  cidr_block = each.value.cidr_block
#  availability_zone = each.value.availability_zone

#  tags = merge(
#    {
#      Name = "${var.common_info.env}-${each.value.subnet_name}"
#    }
#  )
#}

resource "aws_subnet" "subnets_private_db" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_info.cidr_blocks_private_db["private_db_a"].cidr_block
  availability_zone = var.vpc_info.cidr_blocks_private_db["private_db_a"].availability_zone

  tags = merge(
    {
      Name = "${var.common_info.env}-${var.vpc_info.cidr_blocks_private_db["private_db_a"].subnet_name}"
    }
  )
}