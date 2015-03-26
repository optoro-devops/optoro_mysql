template '/etc/mysql/conf.d/db.cnf' do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :run, 'execute[restart mysql]', :immediately
end

execute 'restart mysql' do # ~FC004
  command 'sudo /etc/init.d/mysql stop && sudo /etc/init.d/mysql start'
  retries 3
  action :nothing
end
