#!/bin/bash
# Disable SWAP for all nodes in the cluster.

# -----------------
# Display Memory Usages
#free -m

# Disable Swap Area
swapoff -a

# This step keeps the swap area off during reboot with modifying fstab file.
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# -----------------
