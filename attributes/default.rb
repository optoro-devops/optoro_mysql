default['percona']['server']['package'] = 'percona-server-server-5.5'
default['percona']['server']['replication']['username'] = 'replication'
default['percona']['version'] = '5.5'
default['percona']['server']['bind_address'] = '*'
default['percona']['client']['packages'] = %w(libperconaserverclient18-dev percona-server-client-5.5)
default['percona']['server']['log_bin'] = 'mysql-bin'
default['percona']['server']['relay_log'] = 'mysql-relay-bin'
default['percona']['server']['long_query_time'] = 10
default['percona']['server']['innodb_buffer_pool_size'] = (node['memory']['total'].to_i * 0.7).round(0).to_s + 'kB'
default['percona']['server']['innodb_log_file_size'] = '512M'
default['percona']['server']['innodb_log_buffer_size'] = '4M'
default['percona']['server']['innodb_flush_log_at_trx_commit'] = 2
default['percona']['server']['innodb_thread_concurrency'] = 0
default['percona']['server']['innodb_file_format'] = 'Barracuda'
default['percona']['server']['innodb_lock_wait_timeout'] = 300
default['percona']['server']['query_cache_size'] = 0
default['percona']['server']['sync_binlog'] = 0
default['percona']['server']['log_slave_updates'] = true
default['percona']['server']['key_buffer_size'] = '64M'
default['percona']['server']['max_connections'] = 4000
default['percona']['server']['server_id'] = Chef::Config[:node_name].gsub(/[^0-9]/, '').to_i + 2
default['percona']['server']['performance_schema'] = true
default['percona']['server']['skip_name_resolve'] = true
default['percona']['main_config_file'] = '/etc/mysql/my.cnf'
default['percona']['encrypted_data_bag_secret_file'] = '/etc/chef/encrypted_data_bag_secret'
default['percona']['client']['packages'] = %w(libperconaserverclient18-dev percona-server-client-5.5)
default['percona']['apt']['keyserver'] = 'pool.sks-keyservers.net'
default['percona']['auto_restart'] = false
default['percona']['conf']['mysqld']['innodb_use_native_aio'] = '1'
default['percona']['conf']['mysqld']['innodb-log-group-home-dir'] = node['percona']['server']['datadir']
default['percona']['conf']['mysqld']['innodb_data_home_dir'] = node['percona']['server']['datadir']
default['optoro_mysql'] = {}
default['optoro_mysql']['use_zfs'] = false

# backups
default['optoro_mysql']['backup_directory'] = '/var/optoro/backup'
default['optoro_mysql']['backup'] = true
default['optoro_mysql']['backup_database_name'] = ''
default['optoro_mysql']['backup_database_user'] = ''
default['optoro_mysql']['s3']['bucket'] = 'optoro-db-backups'
default['optoro_mysql']['s3']['region'] = 'us-east-1'
default['optoro_mysql']['s3']['path'] = ''

default['optoro_sensu']['client_attributes']['memory'] = {
  'warning' => '90',
  'critical' => '95'
}

# Consul
default['optoro_consul']['register_consul_service'] = false
