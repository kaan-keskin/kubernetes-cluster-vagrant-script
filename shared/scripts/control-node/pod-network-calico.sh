#!/bin/bash

# -----------------
#
# Installing the Pod network add-on
#

# Install Calico networking and network policy for on-premises deployments
# Source: https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises
sudo -u vagrant curl https://docs.projectcalico.org/manifests/calico.yaml -O
sudo -u vagrant kubectl apply -f calico.yaml

# -----------------
