include_recipe 'optoro_consul::client'

optoro_consul_service 'mysql' do
  port 3306
  params node['optoro_consul']['service']
end
