#!/bin/bash
# HAProxy Load Balancer and IP Failover with KeepAlived 

# Source: https://tecadmin.net/how-to-setup-haproxy-load-balancing-on-ubuntu-linuxmint/
# HAProxy is a very fast and reliable solution for high availability, load balancing, 
# It supports TCP and HTTP-based applications. 
# Nowadays maximizing websites up-time is very crucial for heavy traffic websites. 
# This is not possible with single server setup. 
# Then we need some high availability environment that can easily manage with single server failure.

# Source: https://tecadmin.net/setup-ip-failover-on-ubuntu-with-keepalived/
# Keepalived is used for IP failover between two servers. 
# Its facilities for load balancing and high-availability to Linux-based infrastructures. 
# It worked on VRRP (Virtual Router Redundancy Protocol) protocol. 

# Install Keepalived
apt-get install haproxy keepalived
