#!/bin/bash
# Control Node Preparation Steps for Kubernetes Cluster

CONTROL_NODE_IP="10.0.0.10"
NODE_NAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

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
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Check if there is existing configs folder in the location, and delete it for saving new configuration.
config_path="/vagrant/configs"
if [ -d $config_path ]; then
   rm -f $config_path/*
else
   mkdir -p /vagrant/configs
fi

# Save Kubernetes config file into shared /Vagrant/configs folder.
cp -i /etc/kubernetes/admin.conf /vagrant/configs/config

# Create Kuberentes Cluster join command script into the shared /Vagrant/configs folder.
touch /vagrant/configs/join.sh
chmod +x /vagrant/configs/join.sh       
kubeadm token create --print-join-command > /vagrant/configs/join.sh

#
# Installing a Pod network add-on
#
# Weave Net can be installed onto your CNI-enabled Kubernetes cluster with a single command:
# Source: https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Install Calico networking and network policy for on-premises deployments
# Source: https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises
#curl https://docs.projectcalico.org/manifests/calico.yaml -O
#kubectl apply -f calico.yaml


# Install Kubernetes Metrics Server
# Source: https://github.com/kubernetes-sigs/metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Install Kubernetes Dashboard
# The Dashboard UI is not deployed by default. To deploy it, run the following command:
# Source: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

#
# Create Dashboard User
# Source: https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
#

# Creating a Service Account
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Creating a ClusterRoleBinding
cat <<EOF | kubectl apply -f -
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
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" >> /vagrant/configs/token
