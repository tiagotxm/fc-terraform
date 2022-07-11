resource "aws_vpc" "vpc"{
  cidr_block = var.vpc_cidr_block

  tags = {
    Name="${var.prefix}-vpc"
  }
}

# Get all AZ from AWS
data "aws_availability_zones" "az-available" {}

resource "aws_subnet" "subnets"{
  count = 2
  availability_zone = data.aws_availability_zones.az-available.names[count.index]
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags={
    Name = "${var.prefix}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-rtb"
  }
}

# Associate IGW with RTB. All machines inside subnet will be public
resource "aws_route_table_association" "demo-rtb-association"{
  route_table_id = aws_route_table.rtb.id
  count = 2
  subnet_id = aws_subnet.subnets.*.id[count.index]
}
