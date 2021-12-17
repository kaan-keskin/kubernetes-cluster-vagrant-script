#!/bin/bash
# Common utils for all Kubernetes nodes in the cluster.

# SSHD Service Configuration Script
source ../sshd-conf.sh

# Disable SWAP Script
source swap-off-ubuntu.sh

# KVM Virtualization Initializaiton Script
source kvm-init-ubuntu.sh

# Install System Initialization Script
source system-init-ubuntu.sh

# Install Docker Engine on CentOS
source docker-install-ubuntu.sh

# Installing kubeadm, kubelet and kubectl
source kubeadm-kubelet-kubectl-install-ubuntu.sh

# Installing bash completion on Linux
source ../kubectl-bash-completion-ubuntu.sh

# Installing Helm From Script
source helm-install-ubuntu.sh

# Install kubectx from GitHub
source ../kubectx-install.sh
