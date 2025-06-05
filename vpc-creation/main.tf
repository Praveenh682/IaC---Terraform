
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-igw"
  }
}


resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[0]
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.project}-public-subnet"
  }
}


resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[0]
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.project}-private-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project}-public-rt"
  }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "${var.project}-private-rt"
    }
}

resource "aws_route_table_association" "private_assoc" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id

}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

