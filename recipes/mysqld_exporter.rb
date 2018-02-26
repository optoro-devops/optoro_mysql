include_recipe 'optoro_consul::client'

tar_extract 'https://s3.amazonaws.com/latest-container-assets/mysqld_exporter.tar.gz' do
  user 'root'
  group 'root'
  target_dir '/opt'
end

file '/opt/mysqld_exporter' do
  owner 'root'
  group 'root'
  mode '0755'
end

dbag = Chef::EncryptedDataBagItem.load('passwords', 'mysql')

template '/etc/init/mysqld_exporter.conf' do
  source 'mysqld_exporter.init.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  variables(:user => 'sensu',
            :password => dbag['sensu']['password'])
end

service 'mysqld_exporter' do
  action [:enable, :start]
  supports :restart => true
end

consul_definition 'mysqld-metrics' do
  type 'service'
  parameters(
    port: 9104,
    tags: [node['fqdn']],
    enableTagOverride: false,
    check: {
      interval: '10s',
      timeout: '5s',
      script: 'curl -s http://localhost:9104/metrics > /dev/null'
    }
  )
  notifies :reload, 'consul_service[consul]', :delayed
end
