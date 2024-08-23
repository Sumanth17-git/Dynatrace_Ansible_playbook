#!/bin/bash

# Create the ansible user
sudo adduser ansible --disabled-password --gecos ""

# Grant the ansible user sudo privileges with no password prompt
echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

# Add the ansible user to the sudo group (best practice)
sudo usermod -aG sudo ansible

# Switch to the ansible user and set up SSH directory and permissions
sudo su - ansible -c "
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
"

# Ensure the correct ownership and permissions of the .ssh directory and files
sudo chmod 700 /home/ansible/.ssh
sudo chmod 600 /home/ansible/.ssh/authorized_keys
sudo chown -R ansible:ansible /home/ansible/.ssh

# Configure SSH to allow key-based authentication
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
sudo systemctl restart ssh

# Prompt to paste the public key from the control node
echo "Please paste the public key from the control node below, followed by [ENTER]:"
read -r public_key

# Add the public key to the authorized_keys file for the ansible user
echo "$public_key" | sudo tee -a /home/ansible/.ssh/authorized_keys > /dev/null

# Restart SSH service to ensure the key is recognized
sudo systemctl restart ssh

# Verify the .ssh directory and authorized_keys file
sudo ls -ld /home/ansible/.ssh
sudo ls -l /home/ansible/.ssh/authorized_keys
sudo cat /home/ansible/.ssh/authorized_keys

echo "Ansible target node setup is complete. SSH access should now be configured for the ansible user."
