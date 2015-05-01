# Description

This is a wrapper around the percona cookbook

# Requirements

## Platform:

* Ubuntu (= 14.04)

## Cookbooks:

* percona (~> 0.16.0)
* sysctl
* database (~> 4.0.3)
* logrotate
* cron
* optoro_zfs
* aws
* apt
* openssl
* optoro_metrics

# Attributes

* `node['percona']['server']['package']` -  Defaults to `percona-server-server-5.5`.
* `node['percona']['server']['replication']['username']` -  Defaults to `replication`.
* `node['percona']['version']` -  Defaults to `5.5`.
* `node['percona']['server']['bind_address']` -  Defaults to `*`.
* `node['percona']['client']['packages']` -  Defaults to `%w( libperconaserverclient18-dev percona-server-client-5.5 )`.
* `node['percona']['server']['log_bin']` -  Defaults to `mysql-bin`.
* `node['percona']['server']['relay_log']` -  Defaults to `mysql-relay-bin`.
* `node['percona']['server']['long_query_time']` -  Defaults to `10`.
* `node['percona']['server']['innodb_buffer_pool_size']` -  Defaults to `(node['memory']['total'].to_i * 0.7).round(0).to_s + 'kB`.
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
* `node['percona']['apt']['keyserver']` -  Defaults to `pool.sks-keyservers.net`.
* `node['percona']['auto_restart']` -  Defaults to `false`.
* `node['percona']['conf']['mysqld']['innodb_use_native_aio']` -  Defaults to `1`.
* `node['percona']['conf']['mysqld']['innodb-log-group-home-dir']` -  Defaults to `node['percona']['server']['datadir']`.
* `node['percona']['conf']['mysqld']['innodb_data_home_dir']` -  Defaults to `node['percona']['server']['datadir']`.
* `node['optoro_mysql']` -  Defaults to `{ ... }`.
* `node['optoro_mysql']['use_zfs']` -  Defaults to `false`.
* `node['optoro_mysql']['use_custom_repo']` -  Defaults to `false`.
* `node['optoro_mysql']['repo_uri']` -  Defaults to `http://aptly.optoro.io/percona`.
* `node['optoro_mysql']['arch']` -  Defaults to `amd64`.
* `node['optoro_mysql']['distribution']` -  Defaults to `trusty`.
* `node['optoro_mysql']['components']` -  Defaults to `[ ... ]`.

# Recipes

* [default](#default) - Installs Percona MySQL
* [backup](#backup) - Installs Backup scripts for MySQL
* [logrotate](#logrotate) - Configures rotation of MySQL logs
* [users](#users) - Creates user accounts for MySQL
* [zfs](#zfs) - Creates ZFS device for MySQL data
* [add_percona_repo](#add_percona_repo) - Adds custom percona repository
* [create_mysql_directories](#create_mysql_directories) - Creates directories for mysql files
* [setup](#setup) - Creates random passwords for mysql users
* [log_fix](#log_fix) - Creates a fix for mysql log files
* [test](#test) - Creates test-related items for test kitchen

## default

This is the main recipe for optoro_mysql

## backup

This recipe adds a backup script for mysql.

## logrotate

This recipe adds logrotate functionality for the mysql slow log

## users

This recipe adds mysql users.

## zfs

This recipe adds zfs storage capabilities for mysql.

## add_percona_repo

This recipe adds a custom percona apt repository.

## create_mysql_directories

This recipe adds creates various mysql-related directories

## setup

This recipe creates random passwords for mysql users

## log_fix

This recipe adds a fix for mysql log files.

## test

This recipe creates conditions for testing in kitchen.

# License and Maintainer

Maintainer:: Optoro (<devops@optoro.com>)

License:: MIT
