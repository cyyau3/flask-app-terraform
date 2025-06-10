# ec2.tf
resource "aws_instance" "et-web" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  key_name      = "terraform-et-key"
  subnet_id = aws_subnet.et-public-subnet.id
  vpc_security_group_ids = [aws_security_group.et-security-group.id]
  iam_instance_profile = aws_iam_instance_profile.cw_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-cloudwatch-agent
              dnf install -y postgresql15
              dnf install -y python3 git
              dnf install -y python3-pip

              # Clone your GitHub repo
              cd /home/ec2-user
              git clone https://github.com/cyyau3/flask-expense-tracker
              cd flask-expense-tracker

              # Set permissions
              chown -R ec2-user:ec2-user /home/ec2-user/flask-expense-tracker

              # Set up Python environment
              python3 -m venv venv
              source venv/bin/activate
              pip install --upgrade pip
              pip install -r requirements.txt

              # Create .env file for Flask app with Terraform variables
              cat <<EOT > /home/ec2-user/flask-expense-tracker/.env
              FLASK_ENV=production
              DATABASE_URI=postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.mypostgres.address}:${aws_db_instance.mypostgres.port}/${var.db_name}
              EOT

              # Start Flask app with Gunicorn behind Nginx (assuming Gunicorn installed via requirements.txt)
              nohup gunicorn -b 127.0.0.1:5000 app:app > gunicorn.log 2>&1 &

              # Install and configure Nginx
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx

              cat <<EONGINX > /etc/nginx/nginx.conf
              user nginx;
              worker_processes auto;
              error_log /var/log/nginx/error.log;
              pid /run/nginx.pid;

              events {
                worker_connections 1024;
              }

              http {
                include /etc/nginx/mime.types;
                default_type application/octet-stream;

                access_log /var/log/nginx/access.log;
                sendfile on;
                keepalive_timeout 65;

                server {
                  listen 80;
                  location / {
                    proxy_pass http://127.0.0.1:5000;
                    proxy_set_header Host \$host;
                    proxy_set_header X-Real-IP \$remote_addr;
                    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                    proxy_set_header X-Forwarded-Proto \$scheme;
                  }
                }
              }
              EONGINX

              systemctl restart nginx

              # Write CloudWatch Agent config
              cat <<EOC > /opt/aws/amazon-cloudwatch-agent/bin/config.json
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/messages",
                          "log_group_name": "/aws/ec2/system-log",
                          "log_stream_name": "{instance_id}-system",
                          "timestamp_format": "%b %d %H:%M:%S"
                        },
                        {
                          "file_path": "/home/ec2-user/flask-expense-tracker/gunicorn.log",
                          "log_group_name": "flask-expense-app-tf-log-group",
                          "log_stream_name": "{instance_id}-app",
                          "timestamp_format": "%Y-%m-%d %H:%M:%S"
                        }
                      ]
                    }
                  }
                }
              }
              EOC

              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
                -s
              EOF

  tags = {
    Name = "expense-tracker-tf-ec2"
  }
}