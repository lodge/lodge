bash 'create /etc/postfix/transport' do
  code <<-EOH
  touch /etc/postfix/transport &&
  postmap /etc/postfix/transport
  EOH
end

cookbook_file '/home/vagrant/.gemrc' do
  source '.gemrc'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
end

template '/vagrant/config/database.yml' do
  source 'config/database.yml.erb'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
end

template '/vagrant/.env' do
  source '.env.erb'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  not_if { File.exists?('/vagrant/.env') }
end

template '/vagrant/config/unicorn.rb' do
  source 'config/unicorn.rb.erb'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
end

template '/etc/init.d/lodge' do
  source 'init.d/lodge.erb'
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
end

bash 'bundle install' do
  code <<-EOH
  sudo -u vagrant -i bash -c 'cd /vagrant && bundle install --path vendor/bundle'
  EOH
end

bash 'rake db:create' do
  code <<-EOH
  sudo -u vagrant -i bash -c 'cd /vagrant && bundle exec rake db:create'
  EOH
end

bash 'rake db:migrate' do
  code <<-EOH
  sudo -u vagrant -i bash -c 'cd /vagrant && bundle exec rake db:migrate'
  EOH
end

service 'lodge' do
  action [ :enable, :restart ]
  supports :status => false, :restart => true, :reload => true
end
