#!/bin/bash

## Load the kubectl completion code for bash into the current shell
source <(kubectl completion bash)

## Write bash completion code to a file and source it from .bash_profile
kubectl completion bash > ~/.kube/completion.bash.inc

printf "
# Kubectl shell completion
source '$HOME/.kube/completion.bash.inc'
" >> $HOME/.bash_profile

source $HOME/.bash_profile
