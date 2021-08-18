#!/bin/bash
# Common utils for all nodes in the cluster.

# -----------------

# To make it easier to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
export DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Install required general purpose tools:
apt-get update -y
apt-get upgrade -y
apt-get install -y --no-install-recommends \
  vim \
  git \
  tree \
  htop \
  python3 \
  python3-pip \
  apt-transport-https \
  curl \
  bash-completion \
  tmux

# Install BpyTop on Ubuntu 
pip3 install bpytop

# Clean apt cache
apt autoclean -y
apt autoremove -y
apt clean -y

# -----------------
