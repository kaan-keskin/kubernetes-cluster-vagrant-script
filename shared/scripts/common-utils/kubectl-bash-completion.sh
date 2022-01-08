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
source /home/vagrant/.bash_profile

## Write bash completion script to /etc/bash_completion.d/
mkdir -p /etc/bash_completion.d/
kubectl completion bash > /etc/bash_completion.d/kubectl

## Optional Setup: kubectl shortcuts and aliases:
sudo -u vagrant printf "

# Alias kubectl
alias k='kubectl'

# Alias clear
alias c='clear'

# Auto-Complete kubectl Alias
complete -F __start_kubectl k

# Fast dry-run output
export do="--dry-run=client -o yaml"

# Fast pod delete
export now="--force --grace-period 0"

# Alias Namespace
alias kn='kubectl config set-context --current --namespace '

" >> /home/vagrant/.bashrc

sudo -u vagrant sed -i '1s/^/force_color_prompt=yes\n/' /home/vagrant/.bashrc

# -----------------
