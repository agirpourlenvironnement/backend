# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.provision "shell", path: "Vagrantbootstrap.sh"
  config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: 4
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end
