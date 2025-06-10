#vpc.tf

#VPC
resource "aws_vpc" "et-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "expense-tracker-tf-vpc"
  }
}

#Internet Gateway (IGW)
resource "aws_internet_gateway" "et-gw" {
  vpc_id = aws_vpc.et-vpc.id
}

#Route Table
#rt1: enables communication between AWS and public internet
resource "aws_route_table" "et-route-table-1" {
  vpc_id = aws_vpc.et-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.et-gw.id
  }
}

#rt2: route table for private subnet, no internet route (isolated)
resource "aws_route_table" "et-route-table-2" {
  vpc_id = aws_vpc.et-vpc.id
}

#Subnets
resource "aws_subnet" "et-public-subnet" {
  vpc_id     = aws_vpc.et-vpc.id
  cidr_block = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  
  tags = {
    Name = "expense-tracker-tf-public-subnet"
  }
}

resource "aws_subnet" "et-private-subnet" {
  vpc_id     = aws_vpc.et-vpc.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  
  tags = {
    Name = "expense-tracker-tf-private-subnet"
  }
}

resource "aws_subnet" "et-private-subnet-2" {
  vpc_id     = aws_vpc.et-vpc.id
  cidr_block = var.private_subnet_cidr_block-2
  availability_zone = data.aws_availability_zones.available.names[1]  # must differ from et-private-subnet
  
  tags = {
    Name = "expense-tracker-tf-private-subnet-2"
  }
}

# Associate subnets with Route Table
resource "aws_route_table_association" "et-rt-association-1" {
  subnet_id      = aws_subnet.et-public-subnet.id
  route_table_id = aws_route_table.et-route-table-1.id
}

resource "aws_route_table_association" "et-rt-association-2" {
  subnet_id      = aws_subnet.et-private-subnet.id
  route_table_id = aws_route_table.et-route-table-2.id
}