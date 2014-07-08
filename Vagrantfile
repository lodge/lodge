# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [ ".env", ".git/", ".bundle/", "config/database.yml", "vendor/bundle/", "tmp/", "log/" ]

  # If you'd like to assign private (Host-only) IP address, uncomment the below.
  # config.vm.network "private_network", type: "dhcp"

  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.add_recipe "timezone-ii"
    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "vim"
    chef.add_recipe "postfix"
    chef.add_recipe "mysql::server"
    chef.add_recipe "mysql::client"
    chef.add_recipe "lodge::vagrant"

    chef.json = {
      rbenv: {
        user_installs: [{
          user: 'vagrant',
          rubies: ["2.1.2"],
          global: "2.1.2",
          gems: {
            "2.1.2" => [
              { name: "bundler" },
              { name: "unicorn" }
            ]
          }
        }]
      },
      mysql: {
        server_root_password: ""
      },
      tz: "Asia/Tokyo"
    }
  end

  # Configure the window for gatling to coalesce writes.
  if Vagrant.has_plugin?("vagrant-gatling-rsync")
    config.gatling.latency = 2.5
  end

end
