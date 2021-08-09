#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# Install System Initialization Script
source system-init-oraclelinux7.sh

# Install Docker Engine on CentOS
source docker-install-oraclelinux7.sh

# Installing kubeadm, kubelet and kubectl
source kubeadm-kubelet-kubectl-install-oraclelinux7.sh

# Installing bash completion on Linux
source bash-completion-oraclelinux7.sh

# Installing Helm From Script
source helm-install-oraclelinux7.sh

# Install kubectx from GitHub
source ../kubectx-install.sh
