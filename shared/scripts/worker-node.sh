#!/bin/bash
# Worker Node Preparation Steps for Kubernetes Cluster

# Joining your nodes
# The nodes are where your workloads (containers and Pods, etc) run. 
# To add new nodes to your cluster do the following for each machine:
# SSH to the machine
# Become root (e.g. sudo su -)
# Run the command that was output by kubeadm init.

# Run the created join script:
/bin/bash /vagrant/configs/join.sh -v

sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker-new
EOF