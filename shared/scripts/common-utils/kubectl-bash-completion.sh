#!/bin/bash
# Common utils for all Kubernetes node in the cluster.

# -----------------

## Load the kubectl completion code for bash into the current shell
source <(kubectl completion bash)

## Write bash completion code to a file and source it from .bash_profile
sudo -u vagrant mkdir -p /home/vagrant/.kube/
sudo -u vagrant kubectl completion bash > /home/vagrant/.kube/completion.bash.inc

sudo -u vagrant printf "

# Kubectl shell completion
source '/home/vagrant/.kube/completion.bash.inc'

" >> /home/vagrant/.bash_profile

# source $HOME/.bash_profile

# -----------------
