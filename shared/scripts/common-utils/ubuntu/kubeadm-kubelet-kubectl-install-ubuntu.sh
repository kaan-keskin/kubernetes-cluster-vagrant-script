#!/bin/bash
# Common utils for all Kubernetes nodes in the cluster.

# -----------------
#
# Installing kubeadm, kubelet and kubectl
# Source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
#

# Letting iptables see bridged traffic

# Make sure that the br_netfilter module is loaded. 
# This can be done by running lsmod | grep br_netfilter. 
# To load it explicitly call:
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
modprobe br_netfilter

# As a requirement for your Linux Node's iptables to correctly see bridged traffic, 
# you should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g:
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Update the apt package index and install packages needed to use the Kubernetes apt repository:
apt-get update -y
apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl

# Download the Google Cloud public signing key:
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
apt-get update -y
#KUBERNETES_VERSION="1.21.3-00"
# apt-get install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION
apt-get install -y --no-install-recommends kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Install etcd-client:
apt-get install -y --no-install-recommends \
    etcd-client
export ETCDCTL_API=3

# -----------------
