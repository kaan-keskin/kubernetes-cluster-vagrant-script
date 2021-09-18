#!/bin/bash
# Install NFS Kernel Server in Ubuntu

# -----------------

# Install NFS Kernel Server in Ubuntu:
# Source: https://www.tecmint.com/install-nfs-server-on-ubuntu/
# The first step is to install the nfs-kernel-server package on the server. 
# Once the update is complete, proceed and install the nfs-kernel-server package as shown below. 
# This will store additional packages such as nfs-common and rpcbind which are equally crucial to the setup of the file share.
apt install nfs-kernel-server

# Create an NFS Export Directory:
# The second step will be creating a directory that will be shared among client systems. 
# This is also referred to as the export directory and it’s in this directory 
# that we shall later create files that will be accessible by client systems.
# Run the command below by specifying the NFS mount directory name.
mkdir -p /mnt/nfs_share

# Since we want all the client machines to access the shared directory, 
# remove any restrictions in the directory permissions.
chown -R nobody:nogroup /mnt/nfs_share/

# You can also tweak the file permissions to your preference. 
# Here’s we have given the read, write and execute privileges to all the contents inside the directory.
chmod 777 /mnt/nfs_share/

# Grant NFS Share Access to Client Systems:
# Permissions for accessing the NFS server are defined in the /etc/exports file. 
# So open the file using your favorite text editor:
# sudo vim /etc/exports

# You can provide access to a single client, multiple clients, or specify an entire subnet.
# In this guide, we have allowed an entire subnet to have access to the NFS share.
# /mnt/nfs_share 192.168.43.0/24(rw,sync,no_subtree_check)
# Explanation about the options used in the above command.
# rw: Stands for Read/Write.
# sync: Requires changes to be written to the disk before they are applied.
# No_subtree_check: Eliminates subtree checking.

# -----------------
