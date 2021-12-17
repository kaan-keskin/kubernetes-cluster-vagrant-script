#!/bin/bash

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
sudo -u vagrant kubectl -n kubernetes-dashboard get secret $(sudo -u vagrant kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" >> /vagrant/cluster-conf/kubernetes-dashboard-bearer-token

# -----------------
