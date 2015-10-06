#<
# This recipe adds a backup script for mysql.
#>

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

cookbook_file "#{node['optoro_mysql']['backup_directory']}/backup2.sh" do
  owner 'deploy'
  group 'deploy'
  mode '0755'
end

cron 'backup-cron-job' do
  minute '0'
  hour '5'
  day '*'
  month '*'
  weekday '*'
  user 'deploy'
  command "#{node['optoro_mysql']['backup_directory']}/backup2.sh"
end
