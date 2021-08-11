#!/bin/bash
# Common utils for all Kubernetes nodes in the cluster.

# -----------------

# To make it easier to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
export DEBIAN_FRONTEND=noninteractive
sudo echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

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

# Install BpyTop on Ubuntu 
sudo apt install -y python3-pip
sudo pip3 install bpytop

# Clean apt cache
sudo apt autoclean -y
sudo apt autoremove -y

# -----------------
