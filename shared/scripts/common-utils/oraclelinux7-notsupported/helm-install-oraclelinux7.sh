#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Installing Helm From Script
# Helm now has an installer script that will automatically grab the latest version of Helm and install it locally.
# You can fetch that script, and then execute it locally. 
# It's well documented so that you can read through it and understand what it is doing before you run it.
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo bash ./get_helm.sh

# Configure Default Repo
helm repo add stable https://charts.helm.sh/stable
helm repo update

# -----------------
