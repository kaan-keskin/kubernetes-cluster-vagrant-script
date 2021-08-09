#!/bin/bash

# Install System Initialization Script
source system-init-ubuntu.sh

# Install Docker Engine on CentOS
source docker-install-ubuntu.sh

# Installing kubeadm, kubelet and kubectl
source kubeadm-kubelet-kubectl-install-ubuntu.sh

# Installing bash completion on Linux
source bash-completion-ubuntu.sh

# Installing Helm From Script
source helm-install-ubuntu.sh

# Install kubectx from GitHub
source ../kubectx-install.sh
