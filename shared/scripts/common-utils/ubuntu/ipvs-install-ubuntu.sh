#!/bin/bash
# IPVS Installation for all nodes in the cluster.

# -----------------

# IPVS
# Source: https://github.com/kubernetes/kubernetes/blob/master/pkg/proxy/ipvs/README.md
# 
# What is IPVS?
# IPVS (IP Virtual Server) implements transport-layer load balancing, usually called Layer 4 LAN switching, as part of Linux kernel.
# IPVS runs on a host and acts as a load balancer in front of a cluster of real servers. 
# IPVS can direct requests for TCP and UDP-based services to the real servers, 
# and make services of real servers appear as virtual services on a single IP address.
# 
# Therefore, IPVS naturally supports Kubernetes Service. 
# IPVS mode provides greater scale and performance vs iptables mode.
# 
# IPVS vs. IPTABLES
# IPVS mode was introduced in Kubernetes v1.8, goes beta in v1.9 and GA in v1.11. 
# IPTABLES mode was added in v1.1 and become the default operating mode since v1.2. 
# Both IPVS and IPTABLES are based on netfilter. 
# Differences between IPVS mode and IPTABLES mode are as follows:
# - IPVS provides better scalability and performance for large clusters.
# - IPVS supports more sophisticated load balancing algorithms than IPTABLES (least load, least connections, locality, weighted, etc.).
# - IPVS supports server health checking and connection retries, etc.

# Install ipvs software
# Packages such as ipset should also be installed on the node before using IPVS mode.
apt-get install -y \
  ipset \
  ipvsadm

# Run kube-proxy in IPVS mode
# Currently, local-up scripts, GCE scripts and kubeadm support switching IPVS proxy mode via exporting environment variables or specifying flags.

# Ensure IPVS required kernel modules have been compiled into the node kernel. 
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack
EOF

# Ensure IPVS required kernel modules have been loaded. 
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules
bash /etc/sysconfig/modules/ipvs.modules

# Check active kernel modules with three different method
grep -e ipvs -e nf_conntrack /lib/modules/$(uname -r)/modules.builtin
lsmod | grep -e ip_vs -e nf_conntrack
cut -f1 -d " "  /proc/modules | grep -e ip_vs -e nf_conntrack

# Kube-proxy will fall back to IPTABLES mode if those requirements are not met.

# Test IPVS mode is running
# If ipvs mode is successfully on, you should see IPVS proxy rules (use ipvsadm):
ipvsadm -Ln
