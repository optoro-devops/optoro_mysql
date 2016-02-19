# <
# This recipe creates a trimmed down dump of the database
# >

backup_dir = node['optoro_mysql']['lean_backup_directory']

file "#{backup_dir}/inventory_tables.csv" do
  owner 'deploy'
  group 'deploy'
  mode 0644
  action :nothing
end

file "#{backup_dir}/dev_mysql_dump.rb" do
  owner 'deploy'
  group 'deploy'
  mode 0775
  action :nothing
end

cron 'lean-db-dump-cron-job' do
  minute '0'
  hour '7'
  day '*'
  month '*'
  weekday '*'
  user 'deploy'
  mailto 'devops@optoro.com'
  command "ruby #{backup_dir}/dev_mysql_dump.rb inventory_production"
end
