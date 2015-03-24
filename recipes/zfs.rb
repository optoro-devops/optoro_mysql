file_action = node['optoro_mysql']['zfs'] ? :create : :delete

template '/etc/mysql/conf.d/db.cnf' do
  owner 'root'
  group 'root'
  mode '0644'
  action file_action
  notifies :restart, 'service[mysql]', :delayed
end
