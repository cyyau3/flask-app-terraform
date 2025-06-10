# Example script to update EC2 Security Group with current public IP
# Make sure to export your AWS credentials via environment variables
#!/bin/bash

# Get current public IP
MY_IP=$(curl -s https://checkip.amazonaws.com)
MY_CIDR="${MY_IP}/32"

echo "Detected public IP: $MY_CIDR"

# Update only the my_ip_cidr line in terraform.tfvars
sed -i '' "s|^my_ip_cidr = \".*\"|my_ip_cidr = \"$MY_CIDR\"|" terraform.tfvars
