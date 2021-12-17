#!/bin/bash

# -----------------
# Install Traefik
# Source: https://doc.traefik.io/traefik/getting-started/install-traefik/
# Traefik can be installed in Kubernetes using the 
# Helm chart from https://github.com/traefik/traefik-helm-chart.
# Ensure that the following requirements are met:
# Kubernetes 1.14+
# Helm version 3.x is installed

# Add Traefik's chart repository to Helm:
helm repo add traefik https://helm.traefik.io/traefik

# You can update the chart repository by running:
helm repo update

# And install it with the helm command line:
helm install traefik traefik/traefik

# Exposing the Traefik dashboard
# This HelmChart does not expose the Traefik dashboard by default, for security concerns. 
# Thus, there are multiple ways to expose the dashboard. 
# For instance, the dashboard access could be achieved through a port-forward:
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000
# It can then be reached at: http://127.0.0.1:9000/dashboard/

# Another way would be to apply your own configuration, for instance, 
# by defining and applying an IngressRoute CRD:
# kubectl apply -f dashboard.yaml
