#!/bin/bash

# -----------------
#
# Cluster Configuration and Joining Scripts copied to the shared folder between VMs.
#

# Check if there is existing cluster-conf folder in the location, and delete it for saving new configuration.
config_path="/vagrant/cluster-conf"
if [ -d $config_path ]; then
   rm -rf $config_path/*
else
   mkdir -p "$config_path"
fi

# Save Kubernetes config file into shared /Vagrant/cluster-conf folder.
cp -i /etc/kubernetes/admin.conf /vagrant/cluster-conf/config

# Create Kuberentes Cluster join command script into the shared /Vagrant/cluster-conf folder.
touch /vagrant/cluster-conf/join.sh
chmod +x /vagrant/cluster-conf/join.sh       
kubeadm token create --print-join-command > /vagrant/cluster-conf/join.sh
chown -R vagrant:vagrant /vagrant

# -----------------
