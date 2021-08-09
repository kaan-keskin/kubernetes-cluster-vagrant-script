#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)

# Debug MYOS variable
echo MYOS is set to $MYOS

# To make it easier to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
export DEBIAN_FRONTEND=noninteractive
sudo echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Disable Swap Area
sudo swapoff -a

# This step keeps the swap area off during reboot with modifying fstab file.
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Set Timezone:
sudo timedatectl set-timezone Europe/Istanbul

# Install required general purpose tools:
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y --no-install-recommends \
  vim \
  git \
  tree \
  htop \
  python3 \
  apt-transport-https \
  curl

# Install KVM software
sudo apt-get install -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils

sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

# Install BpyTop on Ubuntu 
sudo apt install -y python3-pip
sudo pip3 install bpytop

# Clean apt cache
sudo apt autoclean -y
sudo apt autoremove -y

# -----------------
