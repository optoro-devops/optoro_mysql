include_recipe 'optoro_consul::client'

consul_definition 'mysql' do
  type 'service'
  parameters(
    port: 3306,
    tags: [node['fqdn'], node['optoro_consul']['service']],
    enableTagOverride: false,
    check: {
      interval: '10s',
      timeout: '5s',
      http: 'http://localhost:3306/metrics'
    }
  )
  notifies :reload, 'consul_service[consul]', :delayed
end
