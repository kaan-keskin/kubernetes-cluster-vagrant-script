#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Upgrade krew
kubectl krew upgrade

# Install sniff plugin
kubectl krew install sniff

# Install tail plugin
kubectl krew install tail

# -----------------
