#!/bin/bash
# SSHD service configuration for all nodes in the cluster.

# -----------------

# Backup initial sshd_config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp

mkdir -p /tmp/sshd/

# Make active PermitRootLogin in the configuration file
sed 's/PermitRootLogin/#PermitRootLogin/g' /etc/ssh/sshd_config > /tmp/sshd/sshd_config
echo 'PermitRootLogin yes' >> /tmp/sshd/sshd_config

# Make active PasswordAuthentication in the configuration file
sed 's/PasswordAuthentication/#PasswordAuthentication/g' /tmp/sshd/sshd_config > /tmp/sshd/sshd_config2
echo 'PasswordAuthentication yes' >> /tmp/sshd/sshd_config2

# Copy new configuraiton file and enable the sshd service
mv -f /tmp/sshd/sshd_config2 /etc/ssh/sshd_config
systemctl restart sshd

# -----------------
