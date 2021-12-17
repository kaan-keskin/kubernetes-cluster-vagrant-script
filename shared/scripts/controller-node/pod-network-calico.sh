#!/bin/bash

# -----------------
#
# Installing the Pod network add-on
#

# Install Calico networking and network policy for on-premises deployments
# Source: https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises
sudo -u vagrant curl https://docs.projectcalico.org/manifests/calico.yaml -O
sudo -u vagrant kubectl apply -f calico.yaml

# Install calicoctl
# More information: https://docs.projectcalico.org/getting-started/clis/calicoctl/install
curl -o calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.20.2/calicoctl" 
mkdir -p /opt/calicoctl
mv calicoctl /opt/calicoctl/
chmod -R 755 /opt/calicoctl
ln -sf /opt/calicoctl/calicoctl /usr/local/bin/calicoctl
sudo -u vagrant cat << FOE >> ~/.bashrc

#calicoctl
export PATH=/opt/calicoctl:\$PATH

FOE

# -----------------
