#vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" : "vpc"
  }
}
#public subnet
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name                         = "public_subnet_${count.index + 1}"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/eks_cluster" = "owned"
  }
}
#private subnet
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name                              = "private_subnet_${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks_cluster"      = "owned"
  }
}
#igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" : "igw"
  }
}
#nat
resource "aws_eip" "nat" {
  tags = {
    "Name" : "nat"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.allocation_id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    "Name" : "nat_gw"
  }
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    "Name" : "private_route_table"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" : "public_route_table"
  }
}
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}