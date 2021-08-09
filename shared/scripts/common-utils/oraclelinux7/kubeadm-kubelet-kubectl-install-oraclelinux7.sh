#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------
#
# Installing kubeadm, kubelet and kubectl
# Source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#

# Disable and stop firewalld service.
sudo systemctl disable --now firewalld

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
