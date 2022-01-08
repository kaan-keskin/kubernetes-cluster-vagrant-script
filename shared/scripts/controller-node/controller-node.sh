#!/bin/bash
# Control Node Preparation Steps for Kubernetes Cluster

# kubeadm initialization steps for control node
source kubeadm-init.sh

# Cluster Configuration and Joining Scripts copied to the shared folder between VMs.
source cluster-conf-join.sh

# Installing the Pod network add-on
source pod-network-calico.sh

# Install Kubernetes Metrics Server
source metrics-server.sh

# Install Kubernetes Dashboard
source kubernetes-dashboard.sh

