#!/bin/bash
# SSHD service configuration for all nodes in the cluster.

# -----------------

# Backup initial sshd_config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp

# Make active PermitRootLogin in the configuration file
sed -i 's/PermitRootLogin/#PermitRootLogin/g' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Make active PasswordAuthentication in the configuration file
sed -i 's/PasswordAuthentication/#PasswordAuthentication/g' /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Restart the sshd service
systemctl restart sshd

# -----------------
