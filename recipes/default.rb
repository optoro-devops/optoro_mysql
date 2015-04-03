include_recipe 'sysctl::default'

sysctl_param 'vm.swappiness' do
  value 0
end

# these must be installed before the mysql chef_gem or it will fail
%w(libmysqlclient-dev build-essential).each do |p|
  pack = package p do
    action :nothing
  end
  pack.run_action(:install)
end

chef_gem 'mysql2' do
  action :install
end

include_recipe 'optoro_mysql::setup'
include_recipe 'percona::server'

directory node['percona']['conf']['mysqld']['innodb_log_group_home'] do
  owner 'mysql'
  group 'mysql'
  mode '0700'
  recursive true
end

directory node['percona']['conf']['mysqld']['innodb_data_home_dir'] do
  owner 'mysql'
  group 'mysql'
  mode '0700'
  recursive true
end

include_recipe 'optoro_mysql::log_fix'
include_recipe 'percona::toolkit'
include_recipe 'percona::backup'
include_recipe 'optoro_mysql::users'
include_recipe 'optoro_mysql::backup'
include_recipe 'optoro_mysql::logrotate'
