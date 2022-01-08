#!/bin/bash
# Time Zone Settings for all nodes in the cluster.

# -----------------

# Set Timezone:
timedatectl set-timezone Europe/Istanbul

# Usually timesync is installed on Ubuntu 20.04.1 LTS by default.
# If not, we can installed by using the following command.
# Note: systemd-timesyncd conflicts with ntp package.
apt-get install -y systemd-timesyncd

# 
# Configuring arbitrary ntp server for systemd-timesyncd:
#

# We simply need to add ntp servers to the configuration file “/etc/systemd/timesyncd.conf“
# Check if the configuration file exists
cat /etc/systemd/timesyncd.conf

# If the command does not return the content and the package is installed, 
# we can use the following command to create the default confutation file
# sudo dpkg-reconfigure systemd-timesyncd

# If you just want to synchronise your computers clock to the network, 
# the configuration file (for the ntpd program from the ntp.org distribution, 
# on any supported operating system - 
# Linux, *BSD, Windows and even some more exotic systems) is really simple: 
printf "
NTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
FallbackNTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
" >> /etc/systemd/timesyncd.conf

# To verify your configuration, use 
timedatectl show-timesync --all

# To enable and start it, simply run:
timedatectl set-ntp true

# Restart the service to apply the changes
systemctl restart systemd-timesyncd.service

# To check if the specified servers are used
systemctl status systemd-timesyncd.service

# The synchronization process might be noticeably slow.
# This is expected, one should wait a while before determining there is a problem.
# We should be able to find the specified server IP addresses 
# from the output with the line start with “Status:” 
# and at the bottom of the output.
# To check the service status, use:
timedatectl status

# To see verbose service information, use:
timedatectl timesync-status

# -----------------
