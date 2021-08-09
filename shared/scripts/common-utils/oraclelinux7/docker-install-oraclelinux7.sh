#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------
#
# Install Docker Engine on CentOS
# Source: https://docs.docker.com/engine/install/centos/
#

# Older versions of Docker were called docker or docker-engine. If these are installed, uninstall them, along with associated dependencies.
sudo yum remove -y \
  docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine

# Install the yum-utils package (which provides the yum-config-manager utility) and set up the stable repository.
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

# Notice that only verified versions of Docker may be installed.
# Verify the documentation to check if a more recent version is available.

# Install the latest version of Docker Engine and containerd, or go to the next step to install a specific version:
sudo yum install -y docker-ce docker-ce-cli containerd.io

[ ! -d /etc/docker ] && sudo mkdir -p /etc/docker

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

sudo mkdir -p /etc/systemd/system/docker.service.d

# Enable and Start Docker Engine Service:
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# -----------------
