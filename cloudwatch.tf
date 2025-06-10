# cloudwatch.tf
resource "aws_iam_role" "cw_agent_role" {
  name = "ec2-cloudwatch-agent-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cw_attach" {
  role       = aws_iam_role.cw_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cw_instance_profile" {
  name = "ec2-cw-agent-profile"
  role = aws_iam_role.cw_agent_role.name
}

resource "aws_cloudwatch_log_group" "flask-expense-tf-log-group" {
  name              = "flask-expense-app-tf-log-group"
  retention_in_days = 14

  tags = {
    Name = "flask-expense-tf-logs"
  }
}


resource "aws_cloudwatch_log_group" "system-log-group" {
  name              = "/aws/ec2/system-log"
  retention_in_days = 14

  tags = {
    Name = "ec2-system-log"
  }
}