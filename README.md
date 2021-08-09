
# Vanilla Kubernetes Cluster Creation Script Using Vagrant

## Prerequisites

Software Prerequisites:
- Vagrant
- Vagrant disksize plugin:
    ```
    vagrant plugin install vagrant-disksize
    ```

Hardware Prerequisites:
- At least 4 CPUs: 
    - 3 vCPUs will be used with cluster VMs
- At least 8GB RAM: 
    - 4GB RAM will be used with cluster VMs

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

You can access Kubernetes Dashboard on the control-node with this command:

```Shell
kubectl proxy &
```

Kubernetes Dashboard can be accessed with this URL:

```shell
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

## Kubernetes Dashboard login token:

"vagrant up" command will create the admin user token in the control-node provision step. 

Admin user access token can be found in the configs directory.

```shell
cd configs
cat token
```
