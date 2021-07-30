#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------
#
# To make it easier to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
export DEBIAN_FRONTEND=noninteractive
sudo echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Disable Swap Area
sudo swapoff -a

# This step keeps the swap area off during reboot with modifying fstab file.
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install required general purpose tools:
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
  vim \
  git \
  tree 

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

#
# Installing kubeadm, kubelet and kubectl
# Source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#

# Letting iptables see bridged traffic

# Make sure that the br_netfilter module is loaded. 
# This can be done by running lsmod | grep br_netfilter. 
# To load it explicitly call:
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
sudo modprobe br_netfilter

# As a requirement for your Linux Node's iptables to correctly see bridged traffic, 
# you should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g:
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# Update the apt package index and install packages needed to use the Kubernetes apt repository:
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl

# Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
sudo apt-get update -y
#KUBERNETES_VERSION="1.21.3-00"
#sudo apt-get install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION
sudo apt-get install -y --no-install-recommends kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# -----------------

# Installing bash completion on Linux
## If bash-completion is not installed on Linux, please install the 'bash-completion' package
## via your distribution's package manager.
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends bash-completion

## Load the kubectl completion code for bash into the current shell
source <(kubectl completion bash)

## Write bash completion code to a file and source it from .bash_profile
kubectl completion bash > ~/.kube/completion.bash.inc

printf "
# Kubectl shell completion
source '$HOME/.kube/completion.bash.inc'
" >> $HOME/.bash_profile

source $HOME/.bash_profile

# -----------------