# rds

resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.et-private-subnet.id, aws_subnet.et-private-subnet-2.id]

  tags = {
    Name = "expense-tracker-tf-rds-subnet-group"
  }
}

resource "aws_db_instance" "mypostgres" {
  identifier              = "expense-tracker-tf-db"
  engine                  = "postgres"
  engine_version          = "17.5"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.et-rds-security-group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds-subnet-group.name
}