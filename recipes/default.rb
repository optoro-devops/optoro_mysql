#<
# This is the main recipe for optoro_mysql
#>
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

include_recipe 'optoro_mysql::zfs' if node['optoro_mysql']['use_zfs']
include_recipe 'optoro_mysql::create_mysql_directories'
include_recipe 'optoro_mysql::setup'
include_recipe 'optoro_mysql::add_percona_repo' if node['optoro_mysql']['use_custom_repo']
include_recipe 'percona::server'
include_recipe 'optoro_mysql::create_inifile'
include_recipe 'optoro_mysql::log_fix'
include_recipe 'percona::toolkit'
include_recipe 'percona::backup'
include_recipe 'optoro_mysql::users'
include_recipe 'optoro_mysql::backup' if node['optoro_mysql']['backup']
include_recipe 'optoro_mysql::logrotate'
include_recipe 'optoro_metrics::mysql'
