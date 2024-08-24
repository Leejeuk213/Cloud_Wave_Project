resource "aws_route_table" "route_table_public" {
 vpc_id = aws_vpc.vpc.id

 tags = merge(
   {
     Name    =  "${var.common_info.env}-${var.common_info.service_name}-public"
   },
   var.common_tags
 )
}

resource "aws_route_table" "route_table_private" {
 vpc_id = aws_vpc.vpc.id

 for_each = var.vpc_info.cidr_blocks_private

 tags = merge(
   {
     Name    = "${var.common_info.env}-${each.value.subnet_name}"
   },
   var.common_tags
 )
}

resource "aws_route_table" "route_table_private_db" {
 vpc_id = aws_vpc.vpc.id

 tags = merge(
   {
     Name    = "${var.common_info.env}-${var.common_info.service_name}-private-db"
   },
   var.common_tags
 )
}

resource "aws_route" "routes_public" {
 route_table_id         = aws_route_table.route_table_public.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route" "routes_private" {
 count = length(var.vpc_info.cidr_blocks_private)

 route_table_id = aws_route_table.route_table_private[keys(var.vpc_info.cidr_blocks_private)[count.index]].id
 destination_cidr_block = "0.0.0.0/0"
 nat_gateway_id = aws_nat_gateway.nat_gateway.id
}


# resource "aws_route" "routes_private" {
#   for_each               = var.vpc_info.cidr_blocks_private

#   route_table_id         = aws_route_table.route_table_private[each.key].id
#   destination_cidr_block = "0.0.0.0/0"
  
#   nat_gateway_id         = lookup(var.vpc_info.private_to_public_map, each.key, null) != null ? aws_nat_gateway.nat_gateway[lookup(var.vpc_info.private_to_public_map, each.key)].id : null
# }

resource "aws_route_table_association" "route_table_association_public" {
 for_each = var.vpc_info.cidr_blocks_public
 
 subnet_id = aws_subnet.subnets_public[each.key].id
 route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_table_association_private" {
 for_each = var.vpc_info.cidr_blocks_private
 
 subnet_id = aws_subnet.subnets_private[each.key].id
 route_table_id = aws_route_table.route_table_private[each.key].id
}

#resource "aws_route_table_association" "route_table_association_private_db" {
# for_each = var.vpc_info.cidr_blocks_private_db

# subnet_id      = aws_subnet.subnets_private_db[each.key].id
# route_table_id = aws_route_table.route_table_private_db.id
#}

resource "aws_route_table_association" "route_table_association_private_db" {
 subnet_id      = aws_subnet.subnets_private_db.id
 route_table_id = aws_route_table.route_table_private_db.id
}