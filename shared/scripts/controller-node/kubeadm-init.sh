#!/bin/bash

# -----------------
# kubeadm initialization steps for control node

# Use the node alias not the IP
# "apiserver-advertise-address" must be ipv4 or ipv6 address!
#CONTROL_NODE_IP="k8scp"
#CONTROL_NODE_IP="kubernetes-controller-node-1"
CONTROL_NODE_IP="10.0.0.11"
NODE_NAME=$(hostname -s)

# 
# Calico is a networking and network policy provider. 
# Calico supports a flexible set of networking options so you can choose the most efficient option for your situation, 
# including non-overlay and overlay networks, with or without BGP. 
# Calico uses the same engine to enforce network policy for hosts, pods, and (if using Istio & Envoy) applications at the service mesh layer. 
# Calico works on several architectures, including amd64, arm64, and ppc64le.
# 
# By default, Calico uses 192.168.0.0/16 as the Pod network CIDR, though this can be configured in the calico.yaml file. 
# For Calico to work correctly, you need to pass this same CIDR to the kubeadm init command 
# using the --pod-network-cidr=192.168.0.0/16 flag or via kubeadm’s configuration.
# 
# CALICO_IPV4POOL_CIDR: "192.168.0.0/16"
# 
POD_CIDR="192.168.0.0/16"
#
# Docker's Default Network CIDR:
#POD_CIDR="172.17.0.0/16" 

# Download all required Docker images:
kubeadm config images pull

#
# Creating a cluster with kubeadm
# Source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
#

# Initializing your control-plane node
kubeadm init --apiserver-advertise-address=$CONTROL_NODE_IP  --apiserver-cert-extra-sans=$CONTROL_NODE_IP --pod-network-cidr=$POD_CIDR --node-name $NODE_NAME --ignore-preflight-errors Swap

# To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:
# To start using your cluster, you need to run the following as a regular user:
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/
export KUBECONFIG=/home/vagrant/.kube/config

# -----------------
