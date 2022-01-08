#!/bin/bash
# Podman and buildah Installation

# -----------------

# Install buildah and podman
# https://github.com/containers/buildah/blob/main/install.md
echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L "https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_20.04/Release.key" | apt-key add -
apt-get update -qq
apt-get install -qq podman
apt-get install -qq buildah

cat <<EOF | tee /etc/containers/registries.conf
[registries.search]
registries = ['docker.io']
EOF

# -----------------
