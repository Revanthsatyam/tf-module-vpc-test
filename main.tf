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

resource "aws_route_table" "example" {
  for_each = var.subnets
  vpc_id = aws_vpc.main.id

  tags = {
    Name = each.key
  }
}