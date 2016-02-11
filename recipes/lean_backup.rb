# <
# This recipe creates a trimmed down dump of the database
# >

backup_dir = node['optoro_mysql']['backup_directory']

directory "#{backup_dir}/lean" do
  action :create
  user 'deploy'
  group 'deploy'
  recursive true
  user 'deploy'
  mode 0775
end

file "#{backup_dir}/lean/inventory_tables.csv" do
  owner 'deploy'
  group 'deploy'
  mode 0775
end

template "#{backup_dir}/lean/lean_dump.rb" do
  source 'lean_dump.rb.erb'
  owner 'deploy'
  group 'deploy'
  mode 0644
end

cron 'lean-db-dump-cron-job' do
  minute '0'
  hour '7'
  day '*'
  month '*'
  weekday '*'
  user 'deploy'
  mailto 'devops@optoro.com'
  command "ruby #{backup_dir}/lean/lean_dump.rb"
end
