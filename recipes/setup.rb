# we need to check the mysql data bag item that contains user information
# if any of the information is incomplete we want to use default values
# and to update the databag on the chef server to contain the new values
#
# example of database that gets loaded here: special users are key/value, additional users are key/hash
#
# {
#   'root' => 'password',
#   'optiturn' => {
#      'host' => 'localhost',
#      'password' => 'blagh',
#      'mysql_permissions' => 'all'
#      'database_name' => ''
#   }
# }

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

mysql_creds = Chef::EncryptedDataBagItem.load(node['percona']['encrypted_data_bag'], 'mysql')

needs_update = false
data_bag_hash = mysql_creds.to_hash

# these are special users to the percona cookbook and should just be a key and a password value
# if the user is not set, add it to the hash a create a password for it
%w( root backup replication ).each do |special_user|
  unless mysql_creds[special_user]
    needs_update = true
    data_bag_hash[special_user] = secure_password
  end
end

# exclude the keys that are used by the percona cookbook
mysql_creds.to_hash.keys.select { |key| key !~ /(id|root|backup|replication)/ }.each do |user|
  user_hash = mysql_creds[user].to_hash

  # these default values will be used for any field that was not specified in the data bag already
  default_user_hash = {
    'host' => 'localhost',
    'mysql_permissions' => 'all',
    'database_name' => 'test',
    'name' => user,
    'password' => secure_password
  }

  needs_update ||= default_user_hash.keys.all? { |k| user_hash.include?(k) }
  data_bag_hash[user] = default_user_hash.merge(user_hash)
end

if needs_update
  secret = Chef::EncryptedDataBagItem.load_secret
  encrypted_bag = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data_bag_hash, secret)
  new_bag_item = Chef::DataBagItem.new
  new_bag_item.data_bag(node['percona']['encrypted_data_bag'])
  new_bag_item.raw_data = encrypted_bag
  new_bag_item.save
end
