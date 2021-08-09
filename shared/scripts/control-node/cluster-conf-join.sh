#!/bin/bash

# -----------------
#
# Cluster Configuration and Joining Scripts copied to the shared folder between VMs.
#

# Check if there is existing configs folder in the location, and delete it for saving new configuration.
config_path="/vagrant/configs"
if [ -d $config_path ]; then
   sudo rm -rf $config_path/*
else
   sudo mkdir -p "$config_path"
fi

# Save Kubernetes config file into shared /Vagrant/configs folder.
sudo cp -i /etc/kubernetes/admin.conf /vagrant/configs/config

# Create Kuberentes Cluster join command script into the shared /Vagrant/configs folder.
sudo touch /vagrant/configs/join.sh
sudo chmod +x /vagrant/configs/join.sh       
sudo kubeadm token create --print-join-command > /vagrant/configs/join.sh
sudo chown -R vagrant:vagrant /vagrant

# -----------------
