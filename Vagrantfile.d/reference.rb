Vagrant.configure("2") do |config|

  # Management/Admin Server
  config.vm.define :management_server do |server|
    server.vm.hostname = "vagrant-management-server"
    server.vm.network :private_network, :ip => $ips[:management_server]
    server.omnibus.chef_version = :latest

    server.vm.provider :virtualbox do |provider|
      provider.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "2"]
      provider.gui = true
    end

    # This is hack until I get a proper Cent64 RPC image
    server.vm.provision :shell, :inline => "yum remove mailx -y"
    server.vm.provision :shell, :inline => "echo '#{$ips[:chef_server]} vagrant-chef-server' >> /etc/hosts"

    server.vm.provision :chef_client do |chef|
      chef.chef_server_url = "https://#{$ips[:chef_server]}"
      chef.validation_key_path = "./.chef-vagrant/chef-validator.pem"
      chef.environment = "swift"

      chef.run_list = [
        "role[spc-starter-controller]"
      ]

      chef.json = {
        "swift-private-cloud" => {
          "dispersion" => {
            "dis_key" => "secrete"
          },
          "keystone" => {
            "auth_password" => "secrete",
            "admin_password" => "secrete",
            "swift_admin_url" => "",
            "swift_public_url" => "",
            "swift_internal_url" => ""
          }
        }
      }
    end
  end

  # Storage Servers
  (1..3).each do |i|
    config.vm.define "storage_server_#{i}" do |server|
      server.vm.hostname = "vagrant-storage-server-#{i}"
      server.vm.network :private_network, :ip => $ips["storage_server_#{i}".to_sym]
      server.omnibus.chef_version = :latest

      server.vm.provider :virtualbox do |provider|
        provider.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "2"]
        provider.gui = true
      end

      # This is hack until I get a proper Cent64 RPC image
      server.vm.provision :shell, :inline => "yum remove mailx -y"
      server.vm.provision :shell, :inline => "echo '#{$ips[:chef_server]} vagrant-chef-server' >> /etc/hosts"

      server.vm.provision :chef_client do |chef|
        chef.chef_server_url = "https://#{$ips[:chef_server]}"
        chef.validation_key_path = "./.chef-vagrant/chef-validator.pem"
        chef.environment = "swift"

        chef.run_list = [
          "role[spc-starter-storage]"
        ]

        chef.json = {
          "swift-private-cloud" => {
            #"dispersion" => {
              #"dis_key" => "secrete"
            #},
            "keystone" => {
              "auth_password" => "secrete",
              "admin_password" => "secrete",
              "swift_admin_url" => "",
              "swift_public_url" => "",
              "swift_internal_url" => ""
            }
          }
        }
      end
    end
  end

  #  Proxy Servers
  (1..2).each do |i|
    config.vm.define "proxy_server_#{i}" do |server|
      server.vm.hostname = "vagrant-proxy-server-#{i}"
      server.vm.network :private_network, :ip => $ips["proxy_server_#{i}".to_sym]
      server.omnibus.chef_version = :latest

      server.vm.provider :virtualbox do |provider|
        provider.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "2"]
        provider.gui = true
      end

      # This is hack until I get a proper Cent64 RPC image
      server.vm.provision :shell, :inline => "yum remove mailx -y"
      server.vm.provision :shell, :inline => "echo '#{$ips[:chef_server]} vagrant-chef-server' >> /etc/hosts"

      server.vm.provision :chef_client do |chef|
        chef.chef_server_url = "https://#{$ips[:chef_server]}"
        chef.validation_key_path = "./.chef-vagrant/chef-validator.pem"
        chef.environment = "swift"

        chef.run_list = [
          "role[spc-starter-proxy]"
        ]

        chef.json = {
          "swift-private-cloud" => {
            #"dispersion" => {
              #"dis_key" => "secrete"
            #},
            "keystone" => {
              "auth_password" => "secrete",
              "admin_password" => "secrete",
              "swift_admin_url" => "",
              "swift_public_url" => "",
              "swift_internal_url" => ""
            }
          }
        }
      end
    end
  end
end
