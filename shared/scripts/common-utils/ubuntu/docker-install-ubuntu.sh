#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------
#
# Install Docker Engine on Ubuntu
# Source: https://docs.docker.com/engine/install/ubuntu/
#

# Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them:
sudo apt-get remove docker docker-engine docker.io containerd runc

# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Use the following command to set up the stable repository.
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index, and install the latest version of Docker Engine and containerd
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io

 # Run Docker commands as vagrant user
sudo usermod -aG docker vagrant

# -----------------
#
# Following configurations are recomended in the Kubenetes documentation for Docker Container Runtime. 
# Source: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
# Configure the Docker daemon, in particular to use systemd for the management of the container’s cgroups.
#
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

# Enable and Start Docker Engine Service:
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# Check Docker Installation
docker info

# -----------------
