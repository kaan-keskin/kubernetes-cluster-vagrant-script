#!/bin/bash
# Docker Installation

# -----------------
#
# Install Docker Engine on Ubuntu
# Source: https://docs.docker.com/engine/install/ubuntu/
#

# Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them:
apt-get remove docker docker-engine docker.io containerd runc

# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt-get update -y
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Use the following command to set up the stable repository.
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index, and install the latest version of Docker Engine and containerd
apt-get update -y
apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io

 # Run Docker commands as vagrant user
usermod -aG docker vagrant

# -----------------
#
# Following configurations are recomended in the Kubenetes documentation for Docker Container Runtime. 
# Source: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
# Configure the Docker daemon, in particular to use systemd for the management of the container’s cgroups.
#
cat <<EOF | tee /etc/docker/daemon.json
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

# Docker and cgroups based on LXC
# Built-in support for cgroups via LXC
# LXC driver must be activated
# sudo echo 'DOCKER_OPTS="--exec-driver=lxc"' >> /etc/default/docker

# Enable and Start Docker Engine Service:
systemctl enable docker
systemctl daemon-reload
systemctl restart docker

# Check Docker Installation
docker info

# Docker Compose Install

# https://docs.docker.com/compose/install/
# Install Compose on Linux systems
# Run this command to download the current stable release of Docker Compose:
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Apply executable permissions to the binary:
chmod +x /usr/local/bin/docker-compose
# Note: If the command docker-compose fails after installation, check your path. 
# You can also create a symbolic link to /usr/bin or any other directory in your path.
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# Test the installation.
docker-compose --version

# Docker Compose Command-line completion
# https://docs.docker.com/compose/completion/
# Install command completion
# Place the completion script in /etc/bash_completion.d/.
curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
# Reload your terminal. You can close and then open a new terminal, 
# or reload your setting with source ~/.bashrc command in your current terminal.
source ~/.bashrc

# -----------------
