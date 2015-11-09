chef_gem 'chef-rewind'
require 'chef/rewind'

mysql_creds = Chef::EncryptedDataBagItem.load(node['percona']['encrypted_data_bag'], 'mysql')

rewind template: '/root/.my.cnf' do
  action :create
  owner 'root'
  group 'root'
  source 'my.cnf.root.erb'
  cookbook_name 'optoro_mysql'
  variables(root_password: mysql_creds['root'])
end
