# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. 
# The "2" in Vagrant.configure configures the configuration version. 
# Please don't change it unless you know what you're doing.

# Script Introduction
puts "--------------------------------------------------"
puts " Kubernetes Cluster Creation Script Using Vagrant "
puts " Author(s): Kaan Keskin "
puts "--------------------------------------------------"

# Platform Compatibility Control
module OS
  def OS.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end
  def OS.mac?
      (/darwin/ =~ RUBY_PLATFORM) != nil
  end
  def OS.unix?
      !OS.windows?
  end
  def OS.linux?
      OS.unix? and not OS.mac?
  end
end
if OS.linux?
  puts " Vagrant script launched on the Linux platform."
  puts "--------------------------------------------------"
else
    puts " Vagrant script launched on the incompatible platform."
    puts " Currently, this script does not support different platform other than Linux."
    puts "------------------------------------------------------------------------------"
    exit 1
end

# Vagrant version requirement
Vagrant.require_version ">= 2.0.0"

# Select VM Provider for your localhost. 
# Options: virtualbox, libvirt, vmware_desktop, docker, hyperv
# Default provider is "virtualbox".
vm_provider = "virtualbox"

# Check if the necessary plugins are installed:
if "vm_provider" == "virtualbox"
  required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-proxyconf vagrant-mutate vagrant-share )
elsif "vm_provider" == "libvirt"
  required_plugins = %w( libvirt vagrant-libvirt vagrant-disksize vagrant-proxyconf vagrant-mutate vagrant-share )
else
  required_plugins = %w( vagrant-disksize vagrant-proxyconf vagrant-mutate vagrant-share )
end
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
  else
      abort "Installation of one or more plugins has failed. Aborting."
  end
end

# Virtual Machine Configuration #
# Vagrant Box Options: "ubuntu/focal64","generic/ubuntu2004"
vm_box = "ubuntu/focal64"
# Increase vm_memory if you want more than 2GB memory in the vm:
vm_memory = 2048
# Increase vm_cpus if you want more cpu's per vm:
vm_cpus = 2
# Increase vm_disksize if you want more than 40GB disk size in the vm:
vm_disksize = "40GB"

# Control Node Configuration #
# Increase number of controller node if you want more than 1 nodes:
num_controllers = 1
# List of all Worker Instances:
controller_instances = []
# Put all worker node IP's with hostnames in the list:
(1..num_controllers).each do |n| 
  controller_instances.push({:name => "kubernetes-controller-node-#{n}", :ip => "10.0.0.1#{n}"})
end

# Worker Node Configuration #
# Increase number of workers if you want more than 3 nodes:
num_workers = 3
# List of all Worker Instances:
worker_instances = []
# Put all worker node IP's with hostnames in the list:
(1..num_workers).each do |n| 
  worker_instances.push({:name => "kubernetes-worker-node-#{n}", :ip => "10.0.0.2#{n}"})
end

# Write hostnames and IP addresses of all nodes to the hosts file:
File.open("./shared/cluster-conf/hosts", 'w') { |file| 
  controller_instances.each do |i|
    file.write("#{i[:ip]} #{i[:name]} #{i[:name]}\n")
  end
  worker_instances.each do |i|
    file.write("#{i[:ip]} #{i[:name]} #{i[:name]}\n")
  end
}

# Proxy Configurations #
# Read Proxy configurations from environment variable:
http_proxy = ""
if ENV['http_proxy']
	http_proxy = ENV['http_proxy']
	https_proxy = ENV['https_proxy']
end

# Create IP list for all nodes for without proxy state:
no_proxy = "localhost,127.0.0.1"
controller_instances.each do |instance|
  no_proxy += ",#{instance[:ip]}"
end
worker_instances.each do |instance|
  no_proxy += ",#{instance[:ip]}"
end

# Decide Automatically Cluster Forming in Docker Swarm Mode
if ENV['AUTO_START_CLUSTER_JOIN']
	auto_join = ENV['AUTO_START_CLUSTER_JOIN']
else
  auto_join = true
end

Vagrant.configure("2") do |config|

  # Set VM provider type and VM resources.
  config.vm.provider vm_provider do |vm|
    vm.memory = vm_memory
    vm.cpus = vm_cpus
  end

  # Controller Node Provisioning
  controller_instances.each do |instance|
    config.vm.define instance[:name] do |i|
      # VM Instance Specific Configuration
      i.vm.box = vm_box
      i.vm.box_check_update = true
      i.vm.hostname = instance[:name]
      i.vm.network "private_network", ip: "#{instance[:ip]}"
      i.disksize.size = vm_disksize
      # VirtualBox supports this feature but libvirt does not support.
      i.vm.provider vm_provider do |vm|
        vm.name = instance[:name]
      end
      # Proxy Configuration
      if not http_proxy.to_s.strip.empty?
        i.proxy.http     = http_proxy
        i.proxy.https    = https_proxy
        i.proxy.no_proxy = no_proxy
      end
      # Shared folder between all instances:
      i.vm.synced_folder "./shared", "/vagrant"
      # Write hostnames and IP addresses of all nodes to the hosts file:
      if File.file?("./shared/cluster-conf/hosts") 
        i.vm.provision "shell", inline: "cat /vagrant/cluster-conf/hosts >> /etc/hosts", privileged: true
      end
      # Install and Configure VM with predefined scripts
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/system-init-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/sshd-conf.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/swap-off-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/kvm-init-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/cgroup-init.ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/timezone-settings-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/docker-install-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/kubeadm-kubelet-kubectl-install-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/kubectl-bash-completion.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/helm-install-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/kubectx-install.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/krew-install.sh", privileged: true
      #i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/kubectl-plugins-install.sh", privileged: true
      # Decide Automatically Cluster Forming in Kubernetes Cluster
      if auto_join
        if "#{instance[:name]}" == "kubernetes-controller-node-1"
          i.vm.provision "shell", inline: "bash /vagrant/scripts/controller-node/kubeadm-init.sh", privileged: true
          i.vm.provision "shell", inline: "bash /vagrant/scripts/controller-node/cluster-conf-join.sh", privileged: true
          i.vm.provision "shell", inline: "bash /vagrant/scripts/controller-node/pod-network-calico.sh", privileged: true
          i.vm.provision "shell", inline: "bash /vagrant/scripts/controller-node/metrics-server/metrics-server.sh", privileged: true
          i.vm.provision "shell", inline: "bash /vagrant/scripts/controller-node/kubernetes-dashboard.sh", privileged: true
          i.vm.provision "shell", inline: "bash /vagrant/scripts/controller-node/ingress/traefik-helm/traefik-helm-install.sh", privileged: true
          #i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/nfs-server-install-ubuntu.sh", privileged: true
        else
          i.vm.provision "shell", inline: "bash /vagrant/scripts/controller-node/controller-node-join.sh", privileged: true
          #i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/nfs-client-install-ubuntu.sh", privileged: true
        end
      end

    end
  end

  # Worker Node Provisioning
  worker_instances.each do |instance|
    config.vm.define instance[:name] do |i|
      # VM Instance Specific Configuration
      i.vm.box = vm_box
      i.vm.box_check_update = true
      i.vm.hostname = instance[:name]
      i.vm.network "private_network", ip: "#{instance[:ip]}"
      i.disksize.size = vm_disksize
      # VirtualBox supports this feature but libvirt does not support.
      i.vm.provider vm_provider do |vm|
        vm.name = instance[:name]
      end
      # Proxy Configuration
      if not http_proxy.to_s.strip.empty?
        i.proxy.http     = http_proxy
        i.proxy.https    = https_proxy
        i.proxy.no_proxy = no_proxy
      end
      # Shared folder between all instances:
      i.vm.synced_folder "./shared", "/vagrant"
      # Write hostnames and IP addresses of all nodes to the hosts file:
      if File.file?("./shared/cluster-conf/hosts") 
        i.vm.provision "shell", inline: "cat /vagrant/cluster-conf/hosts >> /etc/hosts", privileged: true
      end
      # Install and Configure VM with predefined scripts
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/system-init-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/sshd-conf.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/swap-off-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/kvm-init-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/cgroup-init.ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/timezone-settings-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/docker-install-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/kubeadm-kubelet-kubectl-install-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/kubectl-bash-completion.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/helm-install-ubuntu.sh", privileged: true
      #i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/ubuntu/nfs-client-install-ubuntu.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/kubectx-install.sh", privileged: true
      i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/krew-install.sh", privileged: true
      #i.vm.provision "shell", inline: "bash /vagrant/scripts/common-utils/kubectl-plugins-install.sh", privileged: true
      # Decide Automatically Cluster Forming in Kubernetes Cluster
      if auto_join
        i.vm.provision "shell", inline: "bash /vagrant/scripts/worker-node/worker-node.sh", privileged: true
      end

    end 
  end

  end