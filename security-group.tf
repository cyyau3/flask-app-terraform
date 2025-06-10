# security group
resource "aws_security_group" "et-security-group" {
  name        = "et-production-sg"
  description = "Allow web inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.et-vpc.id
  
  tags = {
    Name = "expense-tracker-tf-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "https-from-vpc" {
  security_group_id = aws_security_group.et-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http-from-vpc" {
  security_group_id = aws_security_group.et-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# restrict SSH access to my current IP for security
resource "aws_vpc_security_group_ingress_rule" "ssh-from-vpc" {
  security_group_id = aws_security_group.et-security-group.id
  cidr_ipv4         = var.my_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.et-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# RDS Security Group
resource "aws_security_group" "et-rds-security-group" {
  name        = "et-production-rds-sg"
  description = "only allow ec2 access to rds"
  vpc_id      = aws_vpc.et-vpc.id
  
  tags = {
    Name = "expense-tracker-tf-rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "postgres-from-ec2" {
  security_group_id = aws_security_group.et-rds-security-group.id
  referenced_security_group_id = aws_security_group.et-security-group.id
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}