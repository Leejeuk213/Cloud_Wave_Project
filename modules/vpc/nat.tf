/*
resource "aws_eip" "eip" {
  for_each = var.vpc_info.cidr_blocks_public[0]

  tags = {
    "Name" = "${var.common_info.service_name}-${each.key}-eip"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  for_each = var.vpc_info.cidr_blocks_public[0]

  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = aws_subnet.subnets_public[each.key].id

  tags = {
    Name = "${var.common_info.service_name}-${each.key}-nat"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}
*/

resource "aws_eip" "eip" {
  tags = {
    "Name" = "${var.common_info.service_name}-public_a-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnets_public["public_a"].id

  tags = {
    Name = "${var.common_info.service_name}-public_a-nat"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}