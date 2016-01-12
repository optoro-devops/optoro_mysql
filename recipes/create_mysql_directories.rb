# <
# This recipe adds creates various mysql-related directories
# >

directory node['percona']['conf']['mysqld']['innodb-log-group-home-dir'] do
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

directory '/etc/mysql/conf.d' do
  action :create
  recursive true
end

directory node['percona']['server']['tmpdir'] do
  action :create
  recursive true
end

directory node['percona']['conf']['mysqld']['innodb-log-group-home-dir'] do
  owner 'mysql'
  group 'mysql'
  action :create
  recursive true
end

directory node['percona']['conf']['mysqld']['innodb_data_home_dir'] do
  owner 'mysql'
  group 'mysql'
  action :create
  recursive true
end

directory node['percona']['server']['datadir'] do
  owner 'mysql'
  group 'mysql'
  action :create
end
