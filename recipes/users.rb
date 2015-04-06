mysql_creds = Chef::EncryptedDataBagItem.load(node['percona']['encrypted_data_bag'], 'mysql')
mysql_connection_info = { :host => 'localhost', :username => 'root', :password => mysql_creds['root'] }

# have to remove anonymous user as it causes issues for new users if it still exists
execute 'remove anonymous user' do
  command "mysql -u root -p#{mysql_creds['root']} -e \"DELETE FROM mysql.user WHERE user = ''; flush privileges;\""
end

mysql_creds.to_hash.keys.select { |key| key !~ /(id|root|backup|replication)/ }.each do |user|
  # to select all databases (*) we need to pass in nil and let the cookbook resource use it's default
  # passing in '*' seems like it would make sense but causes a failure
  database = mysql_creds[user]['database_name'] == '*' ? nil : mysql_creds[user]['database_name']

  log mysql_creds.to_hash do
    level :info
  end

  mysql_database_user mysql_creds[user]['name'] do
    connection mysql_connection_info
    database_name database
    password mysql_creds[user]['password']
    host mysql_creds[user]['host']
    privileges mysql_creds[user]['mysql_permissions']
    action [:create, :grant]
  end
end
