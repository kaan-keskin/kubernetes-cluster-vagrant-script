#!/bin/bash
# SSHD service configuration for all Kubernetes nodes in the cluster.

# -----------------

# Backup initial sshd_config file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp

# Make active PermitRootLogin in the configuration file
sudo sed 's/PermitRootLogin/#PermitRootLogin/g' /etc/ssh/sshd_config > /tmp/sshd_config
sudo echo 'PermitRootLogin yes' >> /tmp/sshd_config

# Make active PasswordAuthentication in the configuration file
sudo sed 's/PasswordAuthentication/#PasswordAuthentication/g' /tmp/sshd_config > /tmp/sshd_config2
sudo echo 'PasswordAuthentication yes' >> /tmp/sshd_config2

# Copy new configuraiton file and enable the sshd service
sudo mv -f /tmp/sshd_config2 /etc/ssh/sshd_config
sudo systemctl restart sshd

# -----------------
