variable "region" { type = string }
variable "vpc_cidr" { type = string }
variable "cluster_name" { type = string }

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 0)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-pub-a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, 1)
  tags = {
    Name = "${var.cluster_name}-priv-a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.cluster_name}-igw" }
}

output "vpc_id" { value = aws_vpc.main.id }
output "private_subnet_ids" { value = [aws_subnet.private_a.id] }
output "public_subnet_ids" { value = [aws_subnet.public_a.id] }
