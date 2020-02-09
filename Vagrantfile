Vagrant.configure("2") do |config|
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.define "master-01" do |w1|
   w1.vm.box = "bento/ubuntu-18.04"
   w1.vm.network "private_network", ip: "192.100.50.200"
   w1.vm.hostname = "master"
   w1.vm.provision :shell, path: "script.sh"
   w1.vm.provider "virtualbox" do |w1|
     w1.memory = 1024
     w1.cpus = 2
   end
  end

  config.vm.define "worker-01" do |w1|
   w1.vm.box = "bento/ubuntu-18.04"
   w1.vm.network "private_network", ip: "192.100.50.201"
   w1.vm.hostname = "worker-01"
   w1.vm.provision :shell, path: "script.sh"
   w1.vm.provider "virtualbox" do |w1|
     w1.memory = 2048
     w1.cpus = 2
   end
  end

  config.vm.define "worker-02" do |w1|
   w1.vm.box = "bento/ubuntu-18.04"
   w1.vm.network "private_network", ip: "192.100.50.202"
   w1.vm.hostname = "worker-02"
   w1.vm.provision :shell, path: "script.sh"
   w1.vm.provider "virtualbox" do |w1|
     w1.memory = 2048
     w1.cpus = 2
   end
  end

end
