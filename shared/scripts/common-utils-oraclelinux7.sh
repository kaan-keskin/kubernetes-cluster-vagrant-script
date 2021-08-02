#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------
#

# Disable Swap Area
sudo swapoff -a

# This step keeps the swap area off during reboot with modifying fstab file.
# Disable swap (assuming that the name is /dev/mapper/ol_oracle7-swap).
sudo sed -i 's/^\/dev\/mapper\/ol_oracle7-swap/#\/dev\/mapper\/ol_oracle7-swap/' /etc/fstab
sudo swapoff /dev/mapper/ol_oracle7-swap

# Install required general purpose tools:
sudo yum update -y
sudo yum install -y \
  vim \
  git \
  tree 

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

# Disable and stop firewalld service.
sudo systemctl disable --now firewalld

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

# Red Hat-based distributions:
# 
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
# Setting SELinux in permissive mode by running setenforce 0 and sed ... effectively disables it. 
# This is required to allow containers to access the host filesystem, which is needed by pod networks for example. 
# You have to do this until SELinux support is improved in the kubelet.
# You can leave SELinux enabled if you know how to configure it but it may require settings that are not supported by kubeadm.
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

# -----------------

# Installing bash completion on Linux
## If bash-completion is not installed on Linux, please install the 'bash-completion' package
## via your distribution's package manager.
sudo yum update -y
sudo yum install -y bash-completion

## Write bash completion code to a file and source it from .bash_profile
sudo -u vagrant mkdir -p /home/vagrant/.kube/
sudo -u vagrant kubectl completion bash > /home/vagrant/.kube/completion.bash.inc

sudo -u vagrant printf "
# Kubectl shell completion
source '/home/vagrant/.kube/completion.bash.inc'
" >> /home/vagrant/.bash_profile

# -----------------

# Installing Helm From Script
# Helm now has an installer script that will automatically grab the latest version of Helm and install it locally.
# You can fetch that script, and then execute it locally. 
# It's well documented so that you can read through it and understand what it is doing before you run it.
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo bash ./get_helm.sh

# -----------------

# Install kubectx from GitHub
# More information: https://github.com/ahmetb/kubectx
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo chmod -R 755 /opt/kubectx
sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens
cat << FOE >> ~/.bashrc


#kubectx and kubens
export PATH=/opt/kubectx:\$PATH
FOE

# -----------------
