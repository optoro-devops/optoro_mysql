# <
# This recipe adds a backup script for mysql.
# >

include_recipe 'users'

chef_gem 'backup' do
  version '4.1.9'
  action :install
end

directory '/home/deploy' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

user 'deploy' do
  home '/home/deploy'
  shell '/bin/bash'
end

users_manage 'deploy' do
  action [:remove, :create]
end

if node['optoro_mysql']['use_zfs']
  optoro_zfs 'mysql/backups' do
    mountpoint node['optoro_mysql']['backup_directory']
    atime 'off'
    compression 'lz4'
    recordsize '8k'
  end
else
  directory '/var/optoro' do
    owner 'root'
    group 'root'
    mode '0755'
  end

  directory node['optoro_mysql']['backup_directory'] do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

template "#{node['optoro_mysql']['backup_directory']}/backup2.sh" do
  owner 'deploy'
  group 'deploy'
  mode '0755'
end

# create all the subdirectories in the main backup directory
%w( models log data .tmp ).each do |dirname|
  directory "#{node['optoro_mysql']['backup_directory']}/#{dirname}" do
    recursive true
    user 'deploy'
    group 'deploy'
    mode 0775
    action :create
  end
end

mysql_creds = Chef::EncryptedDataBagItem.load(node['percona']['encrypted_data_bag'], 'mysql')
s3_creds = Chef::EncryptedDataBagItem.load('passwords', 's3')

template "#{node['optoro_mysql']['backup_directory']}/config.rb" do
  source 'config.rb.erb'
  owner 'deploy'
  group 'deploy'
  mode 0644
  variables(
    :s3_access_key_id => s3_creds['access_key_id'],
    :s3_secret_access_key => s3_creds['secret_access_key']
  )
end

template "#{node['optoro_mysql']['backup_directory']}/models/rotation.rb" do
  source 'rotation.rb.erb'
  owner 'deploy'
  group 'deploy'
  mode 0644
  variables(
    :db_name => node['optoro_mysql']['backup_database_name'],
    :db_password => mysql_creds[node['optoro_mysql']['backup_database_user']]['password']
  )
end

cron 'backup-cron-job' do
  minute '0'
  hour '5'
  day '*'
  month '*'
  weekday '*'
  user 'deploy'
  mailto 'devops@optoro.com'
  command "#{node['optoro_mysql']['backup_directory']}/backup2.sh"
end
