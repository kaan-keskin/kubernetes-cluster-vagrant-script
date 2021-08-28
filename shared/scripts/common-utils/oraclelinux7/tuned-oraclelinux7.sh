#!/bin/bash
# tuned - Optimize Pwerformance Settings

# -----------------

# Install tuned administrator tool:
sudo yum install -y \
  tuned-adm \
  tuned

# Enable tuned service:
systemctl enable --now tuned

# Check configuration files in /etc/tuned folder.
# ls /etc/tuned

# List predefined available profiles::
# tuned-adm list

# Optimize for running inside a virtual guest:
# virtual-guest - Optimize for running inside a virtual guest
tuned-adm profile virtual-guest

# -----------------
