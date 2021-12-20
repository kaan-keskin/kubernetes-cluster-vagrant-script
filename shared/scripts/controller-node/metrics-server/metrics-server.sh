#!/bin/bash

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
# ...
# 
# dnsPolicy: ClusterFirst
# hostNetwork: true
# ...
# 

# -----------------
