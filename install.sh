#!/bin/bash

# Create directory for aioznode
sudo mkdir -p /opt/aioznode || { echo "Failed to create /opt/aioznode directory"; exit 1; }

# Create directory ownership for aioznode
sudo chown -R $USER:$USER /opt/aioznode || { echo "Failed to change ownership"; exit 1;}

# Download the aioznode binary
curl -LO https://github.com/AIOZNetwork/aioz-dcdn-cli-node/files/13561211/aioznode-linux-amd64-1.1.0.tar.gz || { echo "Download failed"; exit 1; }

# Extract the binary and move it to the target directory
tar xzf aioznode-linux-amd64-1.1.0.tar.gz && sudo mv aioznode-linux-amd64-1.1.0 /opt/aioznode/aioznode || { echo "Failed to extract and move aioznode"; exit 1; }

# Clean up the downloaded tar.gz file
rm aioznode-linux-amd64-1.1.0.tar.gz || { echo "Warning: Failed to remove the tar.gz file"; }

# Generate private key file
sudo /opt/aioznode/aioznode keytool new --save-priv-key /opt/aioznode/privkey.json || { echo "Failed to generate privkey.json"; exit 1; }

# Set the appropriate permissions for the private key file
sudo chmod 0444 /opt/aioznode/privkey.json || { echo "Failed to set permissions on privkey.json"; exit 1; }

# Create systemd service file
sudo tee /etc/systemd/system/aioznode.service > /dev/null <<EOF || { echo "Failed to create systemd service file"; exit 1; }
[Unit]
Description=Aioz node systemd service by Nodeadmins.com

[Service]
User=$USER
WorkingDirectory=/opt/aioznode/
ExecStart=/opt/aioznode/aioznode start --home nodedata --priv-key-file privkey.json
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the aioznode service
sudo systemctl enable --now aioznode || { echo "Failed to enable and start aioznode service"; exit 1; }

# Wait for a few seconds to let the service start
sleep 8

# Check the status of the service
sudo systemctl status aioznode || { echo "aioznode service is not active"; exit 1; }
echo ""
echo "----------------------------------------------------------------------------"
echo "Aioznode.service created for user $USER. Visit us for more @ Nodeadmins.com"
echo "----------------------------------------------------------------------------"
