#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)

# Debug MYOS variable
echo MYOS is set to $MYOS

# Disable Swap Area
sudo swapoff -a

# This step keeps the swap area off during reboot with modifying fstab file.
# Disable swap (assuming that the name is /dev/mapper/ol_oracle7-swap).
sudo sed -i 's/^\/dev\/mapper\/ol_oracle7-swap/#\/dev\/mapper\/ol_oracle7-swap/' /etc/fstab
sudo swapoff /dev/mapper/ol_oracle7-swap

# Set Timezone:
sudo timedatectl set-timezone Europe/Istanbul

# Install required general purpose tools:
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y \
  vim \
  git \
  tree \
  python3

# Install KVM software
sudo yum install @virtualization -y
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt `id -un`

# Install HTop on Red Hat Linux 7
cd /etc/yum.repos.d
sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y epel-release-latest-7.noarch.rpm
sudo yum install -y htop

# Install BpyTop on CentOS 
sudo yum install -y python3-pip
sudo pip3 install bpytop

# Clean yum cache
sudo yum clean all

# -----------------
