template '/etc/mysql/conf.d/db.cnf' do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, 'service[mysql]', :delayed
end

log_size = node['percona']['server']['innodb_log_file_size'].to_i
log0 = "#{node['percona']['server']['datadir']}/ib_logfile0"
log1 = "#{node['percona']['server']['datadir']}/ib_logfile1"

bash 'fix innodb-log-file-size' do
  action :run
  code <<-EOH
    service mysql stop
    mv #{node['percona']['server']['datadir']}/ib_logfile0 #{node['percona']['server']['datadir']}/ib_logfile0.orig
    mv #{node['percona']['server']['datadir']}/ib_logfile1 #{node['percona']['server']['datadir']}/ib_logfile.orig
    service mysql start
    sleep 60
  EOH

  only_if { (File.size(log0) / 1024 / 1024) != log_size || (File.size(log1) / 1024 / 1024) != log_size }
  not_if { node['optoro_mysql']['ib_logfile_complete'] }
  notifies :run, 'ruby_block[innodb-log-file-size first run]', :immediately
end

ruby_block 'innodb-log-file-size first run' do
  block do
    node.set['optoro_mysql']['ib_logfile_complete'] = true
    node.save
  end
  action :nothing
end
