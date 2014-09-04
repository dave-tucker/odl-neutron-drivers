# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "base.pp"
  end

  config.vm.define "devstack-control" do |dsctl|
    dsctl.vm.box = "trusty64"
    dsctl.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
    dsctl.vm.provider "vmware_fusion" do |v, override|
      override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_ubuntu-14.04_chef-provisionerless.box"
    end
    dsctl.vm.hostname = "devstack-control"
    dsctl.vm.network "private_network", ip: "192.168.50.20"
    dsctl.vm.network "forwarded_port", guest: 8080, host: 8081
    dsctl.vm.provider :virtualbox do |vb|
      vb.memory = 4096
    end
    dsctl.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "4096"
    end
    dsctl.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "devstack-control.pp"
    end
  end

  config.vm.define "devstack-compute" do |dscom|
    dscom.vm.box = "trusty64"
    dscom.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
    dscom.vm.provider "vmware_fusion" do |v, override|
      override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_ubuntu-14.04_chef-provisionerless.box"
    end
    dscom.vm.hostname = "devstack-compute"
    dscom.vm.network "private_network", ip: "192.168.50.21"
    dscom.vm.provider :virtualbox do |vb|
      vb.memory = 4096
    end
    dscom.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "4096"
    end
    dscom.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "devstack-compute.pp"
    end
  end

end
