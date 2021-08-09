#!/bin/bash
# KVM virtualization initializaiton for all Kubernetes nodes in the cluster.

# -----------------

# Setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

# CPU virtualization support control
egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)

# Debug MYOS variable
echo MYOS is set to $MYOS

# Install KVM software
sudo yum install @virtualization -y
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt `id -un`

# Installing the QEMU guest agent
# The qemu-guest-agent is a helper daemon, which is installed in the guest. 
# It is used to exchange information between the host and guest, and to execute command in the guest. 
sudo yum install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent

# KVM Virtualization Status Check
sudo virt-host-validate

# List All KVM Network Interfaces
sudo virsh net-list --all

# Clean yum cache
sudo yum clean all

# -----------------
