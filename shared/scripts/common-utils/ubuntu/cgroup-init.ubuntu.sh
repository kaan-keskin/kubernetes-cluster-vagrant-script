#!/bin/bash
# cgroups - Linux control groups Initialization

# -----------------

# Using libcgroup
apt-get install -y lxc cgroup-lite cgroup-tools

# 
# Kernel Parameters:
# https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/kernel-parameters.txt
#

# Enable the cgroups
# Debian, by default, disables the memory controller.
# We can enable it adding the following in /etc/default/grub.
# 
# GRUB_CMDLINE_LINUX_DEFAULT="
# cgroup_enable=blkio cgroup_enable=cpu cgroup_enable=cpuacct cgroup_enable=cpuset cgroup_enable=devices cgroup_enable=freezer cgroup_enable=memory swapaccount=1
# "
# 
# grubby --update-kernel=ALL \
#   --args="cgroup_enable=blkio cgroup_enable=cpu cgroup_enable=cpuacct cgroup_enable=cpuset cgroup_enable=devices cgroup_enable=freezer cgroup_enable=memory swapaccount=1" 
# update-grub

#
# https://www.kernel.org/doc/Documentation/cgroup-v1/cgroups.txt
# https://www.kernel.org/doc/Documentation/cgroup-v1/memory.txt
# 
# Creating, modifying, using cgroups can be done through the cgroup virtual filesystem.
# 
# To mount a cgroup hierarchy with all available subsystems, type:
# mount -t cgroup cgroup_root /sys/fs/cgroup
#
# To mount a cgroup hierarchy with just the cpuset and memory subsystems, type:
# mount -t cgroup -o cpuset,memory hier1 /sys/fs/cgroup/rg1
# 
# Limit a process to a specific CPU core
# mkdir -p /sys/fs/cgroup/cpuset
# sudo mount -t cgroup cpuset -o cpuset /sys/fs/cgroup/cpuset
# 
# Setting up memory policies
# mkdir -p /sys/fs/cgroup/memory
# sudo mount -t cgroup memory -o memory /sys/fs/cgroup/memory
# 

# Systemd cgroups list:
# systemd-cgls 

# Cgroupspy
# Python wrapper for cgroups
# Integration with libvirt for interacting with VMs
# Developed by and used at CloudSigma
pip3 install cgroupspy

# 
# Configuration Control Steps
# 

# Instead of docker info (which seems to be buggy) use rather lxc-checkconfig or check-config.sh from Docker (moby) repository:
# wget https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh && bash check-config.sh

# CGROUPS Status Check
# cat /sys/fs/cgroup/cgroup.controllers

# KVM Virtualization Status Check
# virt-host-validate

# -----------------
