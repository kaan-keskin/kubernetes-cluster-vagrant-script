
# Vanilla Kubernetes Cluster Creation Script Using Vagrant

## Prerequisites

- At least 4 CPUs: 3 vCPUs will be used with VMs
- At least 8GB RAM: 4GB RAM will be used with VMs
 
## To provision the cluster:

```shell
vagrant up
```

## To shutdown the cluster:

```shell
vagrant halt
```

## To restart the cluster:

```shell
vagrant up
```

## To destroy the cluster: 

```shell
vagrant destroy -f
```

## Kubernetes Dashboard URL:

```shell
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=kubernetes-dashboard
```

## Kubernetes login token

"vagrant up" command will create the admin user token, and will save the token in the configs directory.

```shell
cd configs
cat token
```
