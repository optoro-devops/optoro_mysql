require 'openssl'
mysql_creds = Chef::EncryptedDataBagItem.load(node['percona']['encrypted_data_bag'], 'mysql')
mysql_connection_info = { :host => 'localhost', :username => 'root', :password => mysql_creds['root'] }

#{
#  'root' => 'password',
#  'optiturn' => {
#     'host' => 'localhost',
#     'password' => 'blagh',
#     'mysql_permissions' => 'all'
#
#  }
#}
mysql_creds.keys.each do |user|
  new_user = Chef::EncryptedDataBagItem.load(node['percona']['encrypted_data_bag'], user)

  # to select all databases (*) we need to pass in nil and let the cookbook resource use it's default
  # passing in '*' seems like it would make sense but causes a failure
  database = new_user['database_name'] == '*' ? nil : new_user['database_name']

  mysql_database_user new_user['name'] do
    connection mysql_connection_info
    database_name database
    password new_user['password']
    host new_user['host']
    privileges new_user['mysql_permissions']
    action [:create, :grant]
  end
end
