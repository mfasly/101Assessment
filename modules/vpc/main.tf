locals {
  vpc_id   = aws_vpc.vpc.id
  tag_name = join(".", [var.env, var.project])
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = join(".", [local.tag_name, "vpc"])
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = values(var.public_subnets)[count.index]
  availability_zone = keys(var.public_subnets)[count.index]
  map_public_ip_on_launch = "true"

  tags = {
    Name = join(".", [local.tag_name, "public", "subnet"])
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = values(var.private_subnets)[count.index]
  availability_zone = keys(var.private_subnets)[count.index]

  tags = {
    Name = join(".", [local.tag_name, "private", "subnet"])
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id

  tags = {
    Name = join(".", [local.tag_name, "ig"])
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_eip" "eip" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc = true

  tags = {
    Name = join(".", [local.tag_name, "eip"])
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "private" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = join(".", [local.tag_name, "natgw"])
  }

  depends_on = [aws_eip.eip]
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = join(".", [local.tag_name, "rt"])
  }

  depends_on = [aws_vpc.vpc, aws_internet_gateway.igw]
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id

  depends_on = [aws_vpc.vpc, aws_route_table.public]
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id = local.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private.*.id, count.index)
  }

  tags = {
    Name = join(".", [local.tag_name, "rt"])
  }

  depends_on = [aws_vpc.vpc, aws_subnet.private, aws_nat_gateway.private]
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)

  depends_on = [aws_vpc.vpc, aws_route_table.private]
}

#resource "aws_security_group" "this" {
#  name        = "allow_all"
#  description = "Allow TLS inbound traffic"
#  vpc_id      = aws_vpc.this.id
#  ingress_cidr_blocks = ["0.0.0.0/0"]
#}

#resource "aws_security_group_rule" "allow_all_egress" {
#  type              = "egress"
#  to_port           = 0
#  protocol          = "-1"
#  from_port         = 0
#  security_group_id = aws_security_group.this.id
#}

#resource "aws_security_group_rule" "allow_all_ingress" {
#  type              = "ingress"
#  to_port           = 0
#  protocol          = "-1"
#  from_port         = 0
#  security_group_id = aws_security_group.this.id
#}