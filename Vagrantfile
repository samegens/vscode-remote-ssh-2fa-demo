Vagrant.configure(2) do |config|
  config.vm.define "lnx" do |lnx|
    lnx.vm.box = "ubuntu/focal64"
    lnx.vm.hostname = "lnx"
    lnx.vm.network "private_network", ip: "192.168.13.49"
	  lnx.vm.provision "shell", inline: "/vagrant/prepare.sh"
  end
end
