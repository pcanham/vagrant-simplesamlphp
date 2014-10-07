# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
puppet module install --force puppetlabs-mysql
puppet module install --force puppetlabs-stdlib
puppet module install --force puppetlabs-concat
puppet module install --force puppetlabs-firewall
puppet module install --force puppetlabs-ntp
puppet module install --force puppetlabs-apache
puppet module install --force stahnma-epel
puppet module install --force saz-timezone
puppet module install --force nanliu/staging
SCRIPT


Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize [
      "modifyvm", :id,
      "--memory", "512",
      "--cpus", "2",
      "--natdnspassdomain1", "off",
      ]
  end


  config.vm.define :saml do |saml|
    saml.vm.box = "puppet-centos-65-x64"
    saml.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box"
    saml.vm.network :private_network, ip: "10.0.0.20"
    saml.vm.hostname = "saml"
    saml.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", "2048" ]
    end
    saml.vm.provision :shell, :inline => $script
    saml.vm.provision :puppet,
      :options => ["--debug", "--verbose", "--summarize"],
      :facter => { "fqdn" => "saml.sandbox.internal" } do |puppet|
        puppet.manifests_path = "./"
        puppet.manifest_file = "simplesamlphp.pp"
    end
  end
end
