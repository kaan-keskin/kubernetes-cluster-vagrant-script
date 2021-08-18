#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Installing Helm From Apt (Debian/Ubuntu)
# Members of the Helm community have contributed a Helm package for Apt. This package is generally up to date.
curl https://baltocdn.com/helm/signing.asc | apt-key add -
apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm

# Configure Default Repos
helm repo add stable https://charts.helm.sh/stable
helm repo update

# -----------------
