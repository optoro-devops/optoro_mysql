include_recipe 'optoro_consul::client'

optoro_consul_service 'mysql' do
  checks [
    { script: 'service mysql status', interval: '5s' }
  ]
  port 3306
end
