#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Install kubectx from GitHub
# More information: https://github.com/ahmetb/kubectx
git clone https://github.com/ahmetb/kubectx /opt/kubectx
chmod -R 755 /opt/kubectx
ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -sf /opt/kubectx/kubens /usr/local/bin/kubens
sudo -u vagrant cat << FOE >> ~/.bashrc

#kubectx and kubens
export PATH=/opt/kubectx:\$PATH

FOE

# -----------------
