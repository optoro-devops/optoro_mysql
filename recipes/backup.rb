#<
# This recipe adds a backup script for mysql.
#>

include_recipe 'users'

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

directory '/var/optoro' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/var/optoro/backup' do
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/var/optoro/backup/backup2.sh' do
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
  command '/var/optoro/backup/backup2.sh'
end
