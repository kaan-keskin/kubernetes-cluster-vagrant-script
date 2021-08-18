#!/bin/bash
# KVM virtualization initializaiton for all nodes in the cluster.

# -----------------

# Setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

# CPU virtualization support control
egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)

# Debug MYOS variable
echo MYOS is set to $MYOS

# Install KVM software
apt-get install -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils

adduser `id -un` libvirt
adduser `id -un` kvm

# Installing the QEMU guest agent
# The qemu-guest-agent is a helper daemon, which is installed in the guest. 
# It is used to exchange information between the host and guest, and to execute command in the guest. 
apt-get install -y qemu-guest-agent
# systemctl enable --now qemu-guest-agent

# KVM Virtualization Status Check
# virt-host-validate

# List All KVM Network Interfaces
# virsh net-list --all

# -----------------
