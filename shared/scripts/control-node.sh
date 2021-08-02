#!/bin/bash
# Control Node Preparation Steps for Kubernetes Cluster

CONTROL_NODE_IP="10.0.0.10"
NODE_NAME=$(hostname -s)

# 
# Calico is a networking and network policy provider. 
# Calico supports a flexible set of networking options so you can choose the most efficient option for your situation, 
# including non-overlay and overlay networks, with or without BGP. 
# Calico uses the same engine to enforce network policy for hosts, pods, and (if using Istio & Envoy) applications at the service mesh layer. 
# Calico works on several architectures, including amd64, arm64, and ppc64le.
# 
# By default, Calico uses 192.168.0.0/16 as the Pod network CIDR, though this can be configured in the calico.yaml file. 
# For Calico to work correctly, you need to pass this same CIDR to the kubeadm init command 
# using the --pod-network-cidr=192.168.0.0/16 flag or via kubeadm’s configuration.
# 
# CALICO_IPV4POOL_CIDR: "192.168.0.0/16"
# 
POD_CIDR="192.168.0.0/16"
#
# Docker's Default Network CIDR:
#POD_CIDR="172.17.0.0/16" 

# Download all required Docker images:
sudo kubeadm config images pull

#
# Creating a cluster with kubeadm
# Source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
#

# Initializing your control-plane node
sudo kubeadm init --apiserver-advertise-address=$CONTROL_NODE_IP  --apiserver-cert-extra-sans=$CONTROL_NODE_IP --pod-network-cidr=$POD_CIDR --node-name $NODE_NAME --ignore-preflight-errors Swap

# To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:
# To start using your cluster, you need to run the following as a regular user:
sudo mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/
export KUBECONFIG=/home/vagrant/.kube/config

# -----------------
#
# Cluster Configuration and Joining Scripts copied to the shared folder between VMs.
#

# Check if there is existing configs folder in the location, and delete it for saving new configuration.
config_path="/vagrant/configs"
if [ -d $config_path ]; then
   sudo rm -rf $config_path/*
else
   sudo mkdir -p "$config_path"
fi

# Save Kubernetes config file into shared /Vagrant/configs folder.
sudo cp -i /etc/kubernetes/admin.conf /vagrant/configs/config

# Create Kuberentes Cluster join command script into the shared /Vagrant/configs folder.
sudo touch /vagrant/configs/join.sh
sudo chmod +x /vagrant/configs/join.sh       
sudo kubeadm token create --print-join-command > /vagrant/configs/join.sh
sudo chown -R vagrant:vagrant /vagrant

# -----------------
#
# Installing the Pod network add-on
#

# Weave Net can be installed onto your CNI-enabled Kubernetes cluster with a single command:
# Source: https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
# Alternative source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
#sudo -u vagrant kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Install Calico networking and network policy for on-premises deployments
# Source: https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises
sudo -u vagrant curl https://docs.projectcalico.org/manifests/calico.yaml -O
sudo -u vagrant kubectl apply -f calico.yaml

# -----------------

# Install Kubernetes Metrics Server
# Source: https://github.com/kubernetes-sigs/metrics-server
sudo -u vagrant kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# To use metrics-server you must sign certificates!
# To use without certificate signing/creating you must edit deployment with below lines:
# kubectl -n kube-system edit deployment.apps/metrics-server 
# 
# ...
# spec:
#      containers:
#      - args:
#        - --cert-dir=/tmp
#        - --secure-port=443
#        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
#        - --kubelet-use-node-status-port
#        - --metric-resolution=15s
#        - --kubelet-insecure-tls
#        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
# ...
# 
# dnsPolicy: ClusterFirst
# hostNetwork: true
# ...
# 

# -----------------
#
# Install Kubernetes Dashboard
# The Dashboard UI is not deployed by default. To deploy it, run the following command:
# Source: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
sudo -u vagrant kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

#
# Create default Dashboard User
# Source: https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
#

# Creating a Service Account
cat <<EOF | sudo -u vagrant kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Creating a ClusterRoleBinding
cat <<EOF | sudo -u vagrant kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Getting a Bearer Token
sudo -u vagrant kubectl -n kubernetes-dashboard get secret $(sudo -u vagrant kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" >> /vagrant/configs/token

# -----------------
