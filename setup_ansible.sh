#!/bin/bash

# Update and install essential packages
sudo apt update -y
sudo apt install -y git maven openjdk-17-jdk curl iputils-ping python3 python3-pip software-properties-common

# Verify Maven and Java installations
mvn -version
java -version

# Install Ansible and Ansible Core
sudo apt install -y ansible
sudo add-apt-repository ppa:ansible/ansible --yes --update
sudo apt install -y ansible-core
ansible --version

# Create the 'ansible' user and configure sudo privileges
sudo adduser ansible --disabled-password --gecos ""
sudo usermod -aG sudo ansible

# Configure sudoers for 'ansible' user with no password prompt
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Set up SSH access for the 'ansible' user
sudo -u ansible ssh-keygen -t rsa -b 4096 -N "" -f /home/ansible/.ssh/id_rsa
echo "Public key for ansible user:"
cat /home/ansible/.ssh/id_rsa.pub

# Add the public key to authorized_keys on the target nodes
# This assumes you have SSH access to the target nodes
# Replace 192.168.1.105 with your target node IP(s)
TARGET_NODES=("192.168.1.105")
for node in "${TARGET_NODES[@]}"; do
    ssh-copy-id -i /home/ansible/.ssh/id_rsa.pub ansible@$node
done

# Configure Ansible to use the 'ansible' user by default
sudo bash -c 'echo -e "[defaults]\nremote_user = ansible\nbecome = True\nbecome_method = sudo" >> /etc/ansible/ansible.cfg'

# Set up inventory file
sudo bash -c 'echo -e "[web]\n192.168.1.105" >> /etc/ansible/hosts'

echo "Setup complete. Ansible is configured and ready to use."
