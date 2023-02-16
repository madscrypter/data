#!/bin/bash



# Run the installation script with the specified inputs
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

# Check if the installation was successful
if [ $? -eq 0 ]; then
  echo "V2RAY installed successfully"
  
  # Check if UFW is installed and apply firewall rules
  if command -v ufw &> /dev/null; then
    echo "UFW is installed, configuring firewall rules..."
    
    # Allow traffic on port 6618
    sudo ufw allow 6618

    # Allow SSH access only from the IP range 195.0.0.0/8
    sudo ufw allow from 195.0.0.0/8 to any port 22 proto tcp
    
    # Delete any existing rules for SSH access from anywhere
    sudo ufw delete allow 22/tcp
    

    
    # Disable UFW before running Certbot
    sudo ufw disable
  fi
  
  # Install Certbot
  sudo apt install software-properties-common -y
  sudo add-apt-repository -y ppa:certbot/certbot
  sudo apt-get update
  sudo apt-get install certbot -y
  
  # Ask for Cloudflare subdomain
  read -p "What is the Cloudflare subdomain? " subdomain
  
  # Run Certbot command with the entered subdomain
  sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email agate@tuta.io -d "$subdomain"
else
  echo "V2RAY installation failed"
fi
