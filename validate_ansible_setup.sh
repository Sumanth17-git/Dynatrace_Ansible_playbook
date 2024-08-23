#!/bin/bash

# Define the target node IP address
TARGET_IP="10.128.0.20"

# Connect to the target node using SSH (you will need to manually type 'yes' to accept the key)
echo "Connecting to $TARGET_IP..."
ssh ansible@$TARGET_IP

# Copy the SSH key to the target node
echo "Copying SSH key to $TARGET_IP..."
ssh-copy-id ansible@$TARGET_IP

# Ping all hosts in the Ansible inventory
echo "Pinging all hosts in Ansible inventory..."
ansible all -m ping

# List all hosts in the Ansible inventory
echo "Listing all hosts in Ansible inventory..."
ansible all --list-hosts

# Open Ansible console for interactive command execution
echo "Opening Ansible console..."
ansible-console all

# Test running commands directly from the Ansible console (interactive mode)
# Example: Run a simple command, such as "uname -a" to check the OS on the hosts
echo "Run commands directly in the Ansible console (type 'exit' to quit the console)."
echo "For example, try 'uname -a' to see the OS on the target nodes."
ansible-console all 

# List the Ansible inventory in a more detailed format
echo "Listing detailed Ansible inventory..."
ansible-inventory --list

# Test passwordless sudo access on the target node
echo "Testing passwordless sudo access on the target node..."

# Switch to the 'ansible' user on the target node
echo "Switching to 'ansible' user on $TARGET_IP..."
ssh ansible@$TARGET_IP <<EOF
    sudo whoami
EOF

echo "Passwordless sudo access should output 'root' without prompting for a password."
