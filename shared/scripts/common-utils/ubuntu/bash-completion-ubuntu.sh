#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

# Installing bash completion on Linux
## If bash-completion is not installed on Linux, please install the 'bash-completion' package
## via your distribution's package manager.
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends bash-completion

## Write bash completion code to a file and source it from .bash_profile
sudo -u vagrant mkdir -p /home/vagrant/.kube/
sudo -u vagrant kubectl completion bash > /home/vagrant/.kube/completion.bash.inc

sudo -u vagrant printf "

# Kubectl shell completion
source '/home/vagrant/.kube/completion.bash.inc'

" >> /home/vagrant/.bash_profile

# -----------------
