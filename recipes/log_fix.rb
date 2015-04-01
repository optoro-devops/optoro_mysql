log_size = node['percona']['server']['innodb_log_file_size'].to_i * 1024 * 1024
log0 = "#{node['percona']['server']['datadir']}/ib_logfile0"
log1 = "#{node['percona']['server']['datadir']}/ib_logfile1"

Chef::Log.debug("alex-test: #{log_size}")

bash 'fix innodb-log-file-size' do
  action :run
  code <<-EOH
    service mysql stop
    if [ -f #{log0} ] ; then mv #{log0} #{log0}.orig ; fi
    if [ -f #{log1} ] ; then mv #{log1} #{log1}.orig ; fi
    service mysql start
    sleep 60
  EOH

  only_if { (::File.exist?(log0) && ::File.size(log0) != log_size) || (::File.exist(log1) && ::File.size(log1) != log_size) }
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
