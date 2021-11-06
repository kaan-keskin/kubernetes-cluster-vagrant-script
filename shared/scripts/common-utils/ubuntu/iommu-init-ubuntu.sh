#!/bin/bash
# cgroups - Linux control groups Initialization

# -----------------

# 
# Kernel Parameters:
# https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/kernel-parameters.txt
#

# TO-DO
usermod -aG libvirt vagrant
systemctl start libvirtd.service
systemctl enable libvirtd.service
systemctl status libvirtd.service

# 
# Enable the IOMMU
# You need to enable the IOMMU, by editing the kernel commandline. 
# 
# GRUB_CMDLINE_LINUX_DEFAULT="
# iommu=pt intel_iommu=on amd_iommu=on
# "
# 
grubby --update-kernel=ALL \
  --args="iommu=pt intel_iommu=on" 
update-grub

# Verify IOMMU is enabled
dmesg | grep -e DMAR -e IOMMU

# 
# IOMMU Interrupt Remapping
# 
# It will not be possible to use PCI passthrough without interrupt remapping. 
# Device assignment will fail with 
# 'Failed to assign device "[device name]": Operation not permitted' or 'Interrupt Remapping hardware not found, passing devices to unprivileged domains is insecure.' error.
# All systems using an Intel processor and chipset that have support for 
# Intel Virtualization Technology for Directed I/O (VT-d), 
# but do not have support for interrupt remapping will see such an error. 
# Interrupt remapping support is provided in newer processors and chipsets (both AMD and Intel).

# To identify if your system has support for interrupt remapping:
dmesg | grep 'remapping'

# If your system doesn't support interrupt remapping, 
# you can allow unsafe interrupts with:
echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf

# Required Modules add to /etc/modules:
printf "
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
" >> /etc/modules

# 
# Configuration Control Steps
# 

# KVM Virtualization Status Check
virt-host-validate


# -----------------
