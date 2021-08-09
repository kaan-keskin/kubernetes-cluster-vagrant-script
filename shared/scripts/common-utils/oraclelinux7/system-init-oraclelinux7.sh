#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Set Timezone:
sudo timedatectl set-timezone Europe/Istanbul

# Install required general purpose tools:
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y \
  vim \
  git \
  tree \
  python3 \
  curl

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
