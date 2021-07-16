#!/bin/bash
# Worker Node Preparation Steps for Kubernetes Cluster

# Joining your nodes
# The nodes are where your workloads (containers and Pods, etc) run. 
# To add new nodes to your cluster do the following for each machine:
# SSH to the machine
# Become root (e.g. sudo su -)
# Run the command that was output by kubeadm init.

# Run the created join script:
sudo bash /vagrant/configs/join.sh

sudo -u vagrant mkdir -p /home/vagrant/.kube
sudo -u vagrant cp -i /vagrant/configs/config /home/vagrant/.kube/
export NODENAME=$(hostname -s)
sudo -u vagrant kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker-new
