include_recipe 'optoro_consul::client'

# always want fqdn as a tag...if there are additional service tags specified
# then add them to the tags array as well, have to check that keys exist to avoid explosion
tags = (node['optoro_consul'].key?('service') ? node['optoro_consul']['service'].fetch('tags', []) : []) | [node['fqdn']]

mysql_creds = Chef::EncryptedDataBagItem.load(node['percona']['encrypted_data_bag'], 'mysql').to_hash

consul_definition 'mysql' do
  type 'service'
  parameters(
    port: 3306,
    tags: tags,
    enableTagOverride: false,
    check: {
      interval: '10s',
      script: "mysql -uroot --password=#{mysql_creds['root']} -e 'show databases'"
    }
  )
  notifies :reload, 'consul_service[consul]', :delayed
end
