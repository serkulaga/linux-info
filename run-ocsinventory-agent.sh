#!/bin/bash

# Check for the required parameters
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <server> <tag>"
  exit 1
fi

# Assign command-line arguments to variables
OCS_SERVER="$1"
OCS_TAG="$2"

# Pre-seed the debconf values including the custom "tag" setting
sudo debconf-set-selections <<EOF
ocsinventory-agent  ocsinventory-agent/method   select  http
ocsinventory-agent  ocsinventory-agent/server   string  ${OCS_SERVER}
ocsinventory-agent  ocsinventory-agent/tag      string  ${OCS_TAG}
EOF

# Install ocsinventory-agent non-interactively
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ocsinventory-agent

# run agent
sudo ocsinventory-agent --ssl=0


# delete agent
#sudo apt remove -y ocsinventory-agent
