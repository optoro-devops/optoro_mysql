# Description

This is a wrapper around the percona cookbook

# Requirements

## Platform:

* Ubuntu (= 14.04)

## Cookbooks:

* percona (~> 0.16.0)
* sysctl
* database (~> 4.0.3)
* apt
* logrotate
* cron
* optoro_metrics

# Attributes

* `node['percona']['server']['package']` -  Defaults to `percona-server-server-5.5`.
* `node['percona']['version']` -  Defaults to `5.5`.
* `node['percona']['server']['bind_address']` -  Defaults to `*`.
* `node['percona']['client']['packages']` -  Defaults to `%w( libperconaserverclient18-dev percona-server-client-5.5 )`.
* `node['percona']['server']['log_bin']` -  Defaults to `mysql-bin`.
* `node['percona']['server']['relay_log']` -  Defaults to `mysql-relay-bin`.
* `node['percona']['server']['long_query_time']` -  Defaults to `10`.
* `node['percona']['server']['innodb_buffer_pool_size']` -  Defaults to `(node['memory']['total'].to_i * 0.8).round(0).to_s + 'kB`.
* `node['percona']['server']['innodb_log_file_size']` -  Defaults to `512M`.
* `node['percona']['server']['innodb_log_buffer_size']` -  Defaults to `4M`.
* `node['percona']['server']['innodb_flush_log_at_trx_commit']` -  Defaults to `2`.
* `node['percona']['server']['innodb_thread_concurrency']` -  Defaults to `0`.
* `node['percona']['server']['innodb_file_format']` -  Defaults to `Barracuda`.
* `node['percona']['server']['innodb_lock_wait_timeout']` -  Defaults to `300`.
* `node['percona']['server']['query_cache_size']` -  Defaults to `0`.
* `node['percona']['server']['sync_binlog']` -  Defaults to `0`.
* `node['percona']['server']['log_slave_updates']` -  Defaults to `true`.
* `node['percona']['server']['key_buffer_size']` -  Defaults to `64M`.
* `node['percona']['server']['max_connections']` -  Defaults to `4000`.
* `node['percona']['server']['server_id']` -  Defaults to `Chef::Config[:node_name].gsub(/[^0-9]/, '').to_i + 2`.
* `node['percona']['main_config_file']` -  Defaults to `/etc/mysql/my.cnf`.
* `node['percona']['encrypted_data_bag_secret_file']` -  Defaults to `/etc/chef/encrypted_data_bag_secret`.
* `node['percona']['apt_keyserver']` -  Defaults to `pgp.mit.edu`.
* `node['percona']['auto_restart']` -  Defaults to `false`.
* `node['optoro_mysql']['users']` -  Defaults to `%w( optiturn monitor optiturn_local spexy link repl vividcortex sensu )`.
* `node['optoro_mysql']['zfs']` -  Defaults to `false`.
* `node['optoro_mysql']['innodb_log_dir']` -  Defaults to `/var/lib/mysql-innodb`.

# Recipes

* default - Installs Percona MySQL
* backup - Installs Backup scripts for MySQL
* logrotate - Configures rotation of MySQL logs
* users - Creates user accounts for MySQL
* zfs - Creates ZFS device for MySQL data

# License and Maintainer

Maintainer:: Optoro (<devops@optoro.com>)

License:: MIT
