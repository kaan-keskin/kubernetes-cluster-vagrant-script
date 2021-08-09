#!/bin/bash
# Disable SWAP for all Kubernetes nodes in the cluster.

# -----------------

# Disable Swap Area
sudo swapoff -a

# This step keeps the swap area off during reboot with modifying fstab file.
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# -----------------
