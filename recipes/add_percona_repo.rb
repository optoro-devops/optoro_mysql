apt_repository 'percona' do
  action :add
  uri node['optoro_mysql']['repo_uri']
  distribution node['optoro_mysql']['distribution']
  components node['optoro_mysql']['components']
  arch node['optoro_mysql']['arch']
  notifies :run, 'execute[apt-get update]', :immediately
end

execute 'apt-cache gencaches' do
  ignore_failure true
  action :nothing
end

execute 'apt-get update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
  notifies :run, 'execute[apt-cache gencaches]', :immediately
end
