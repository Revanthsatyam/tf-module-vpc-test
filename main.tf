resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "main" {
  for_each = var.subnets
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = each.key
  }
}

resource "aws_route_table_association" "main" {
  for_each       = var.subnets
  subnet_id      = lookup(lookup(aws_subnet.main, each.key, null), "id", null)
  route_table_id = lookup(lookup(aws_route_table.main, each.key, null), "id", null)
}