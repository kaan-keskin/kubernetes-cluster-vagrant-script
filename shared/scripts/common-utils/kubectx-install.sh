#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Install kubectx from GitHub
# More information: https://github.com/ahmetb/kubectx
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo chmod -R 755 /opt/kubectx
sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens
cat << FOE >> ~/.bashrc

#kubectx and kubens
export PATH=/opt/kubectx:\$PATH

FOE

# -----------------
