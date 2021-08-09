#!/bin/bash
# Disable SWAP for all Kubernetes nodes in the cluster.

# -----------------

# Disable Swap Area
sudo swapoff -a

# This step keeps the swap area off during reboot with modifying fstab file.
# Disable swap (assuming that the name is /dev/mapper/ol_oracle7-swap).
sudo sed -i 's/^\/dev\/mapper\/ol_oracle7-swap/#\/dev\/mapper\/ol_oracle7-swap/' /etc/fstab
sudo swapoff /dev/mapper/ol_oracle7-swap

# -----------------
