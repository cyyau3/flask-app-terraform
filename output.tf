# output.tf
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.et-web.public_ip
}

# output "ec2_public_dns" {
#   description = "Public DNS of the EC2 instance"
#   value       = aws_instance.et-web.public_dns
# }

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.et-vpc.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.et-security-group.id
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.mypostgres.endpoint
}

output "rds_port" {
  description = "Port to connect to the RDS instance"
  value       = aws_db_instance.mypostgres.port
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.mypostgres.id
}