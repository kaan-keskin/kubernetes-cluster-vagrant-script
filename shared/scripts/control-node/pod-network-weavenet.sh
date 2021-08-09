#!/bin/bash

# -----------------
#
# Installing the Pod network add-on
#

# Weave Net can be installed onto your CNI-enabled Kubernetes cluster with a single command:
# Source: https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
# Alternative source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
sudo -u vagrant kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# -----------------
