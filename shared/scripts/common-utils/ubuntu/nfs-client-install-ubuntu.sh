#!/bin/bash
# Install NFS Common Package in Ubuntu

# -----------------

# Install NFS Common package in Ubuntu:
apt-get install nfs-common

# Check NFS Mount Address
showmount -e kubernetes-controller-node-1

# Create an NFS Export Directory:
# Run the command below by specifying the NFS mount directory name.
mkdir -p /mnt/nfs_share

# Since we want all the client machines to access the shared directory, 
# remove any restrictions in the directory permissions.
chown -R nobody:nogroup /mnt/nfs_share/

# You can also tweak the file permissions to your preference. 
# Here’s we have given the read, write and execute privileges to all the contents inside the directory.
# Make and populate a directory to be shared. Also give it similar permissions to /tmp/ .
chmod 1777 /mnt/nfs_share/

# Grant NFS Share Access to Client Systems:
# Mount the directory. 
# Be aware that unless you edit /etc/fstab this is not a persistent mount. 
# Change out the node name for that of your control plane node.
mount kubernetes-controller-node-1:/mnt/nfs_share /mnt/nfs_share

# List mounted NFS share content
ls -l /mnt/nfs_share

# Check mount status
showmount -e localhost

# -----------------
