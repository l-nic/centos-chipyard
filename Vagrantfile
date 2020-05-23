# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provision :shell, path: "root-bootstrap.sh"
#  config.vm.provision :shell, privileged: false, path: "user-bootstrap.sh"
  config.vm.network :forwarded_port, guest: 22, host: 2223, id: "ssh"
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  config.disksize.size = "256GB"
  config.vm.provider "virtualbox" do |v|
    v.memory = 16384
    v.cpus = 16
  end
end
