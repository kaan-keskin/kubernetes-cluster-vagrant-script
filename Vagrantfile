Vagrant.configure("2") do |config|

    config.vm.provision "shell", inline: <<-SHELL
      echo "10.0.0.10  control-node" >> /etc/hosts
      echo "10.0.0.11  worker-node-01" >> /etc/hosts
      echo "10.0.0.12  worker-node-02" >> /etc/hosts
    SHELL
    
    config.vm.define "control" do |control|
      control.vm.box = "bento/ubuntu-20.04"
      control.vm.box_check_update = true
      control.vm.hostname = "control-node"
      control.vm.network "private_network", ip: "10.0.0.10"
      control.disksize.size = "200GB"
      control.vm.provider "virtualbox" do |vb|
        vb.name = "vanilla-kubernetes-cluster-control-node"
        vb.memory = 4048
        vb.cpus = 2
      end
      control.vm.synced_folder "./shared", "/vagrant"
      control.vm.provision "shell", inline: <<-SHELL
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp
        sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config > /tmp/sshd_config
        sed 's/PasswordAuthentication no/PasswordAuthentication yes/g' /tmp/sshd_config > /tmp/sshd_config2
        mv -f /tmp/sshd_config2 /etc/ssh/sshd_config
        systemctl restart sshd
      SHELL
      control.vm.provision "shell", path: "shared/scripts/common-utils.sh"
      control.vm.provision "shell", path: "shared/scripts/control-node.sh"
    end

    (1..2).each do |i|
  
    config.vm.define "node-0#{i}" do |node|
      node.vm.box = "bento/ubuntu-20.04"
      node.vm.box_check_update = true
      node.vm.hostname = "worker-node-0#{i}"
      node.vm.network "private_network", ip: "10.0.0.1#{i}"
      node.disksize.size = "200GB"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "vanilla-kubernetes-cluster-worker-node-0#{i}"
        vb.memory = 2048
        vb.cpus = 1
      end
      node.vm.synced_folder "./shared", "/vagrant"
      node.vm.provision "shell", inline: <<-SHELL
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp
        sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config > /tmp/sshd_config
        sed 's/PasswordAuthentication no/PasswordAuthentication yes/g' /tmp/sshd_config > /tmp/sshd_config2
        mv -f /tmp/sshd_config2 /etc/ssh/sshd_config
        systemctl restart sshd
      SHELL
      node.vm.provision "shell", path: "shared/scripts/common-utils.sh"
      node.vm.provision "shell", path: "shared/scripts/worker-node.sh"
    end
    
    end
  end