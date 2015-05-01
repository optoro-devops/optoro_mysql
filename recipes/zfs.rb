#<
# This recipe adds zfs storage capabilities for mysql.
#>
include_recipe 'optoro_zfs'
include_recipe 'aws'

directory '/etc/mysql/conf.d' do
  action :create
  recursive true
end

cookbook_file '/etc/mysql/conf.d/zfs-hack-db.cnf' do
  action :create
end

directory node['percona']['server']['tmpdir'] do
  action :create
  recursive true
end

directory node['percona']['conf']['mysqld']['innodb-log-group-home-dir'] do
  action :create
  recursive true
end

directory node['percona']['conf']['mysqld']['innodb_data_home_dir'] do
  action :create
  recursive true
end

directory node['percona']['server']['datadir'] do
  action :create
end

aws_ebs_volume 'zfs_zil' do
  size 20
  device '/dev/sdi'
  volume_type 'io1'
  piops 600
  action [:create, :attach]
end

aws_ebs_volume 'zfs_cache' do
  size 20
  device '/dev/sdg'
  volume_type 'gp2'
  action [:create, :attach]
end

aws_ebs_volume 'zfs_data' do
  size 250
  device '/dev/sdh'
  action [:create, :attach]
end

zpool 'mysql' do
  disks ['/dev/xvdh']
  log_disks ['/dev/xvdi']
  cache_disks ['/dev/xvdg']
  mountpoint 'none'
  force true
end

zfs 'mysql/mysql' do
  mountpoint node['percona']['server']['datadir']
  atime 'off'
  compression 'lz4'
  recordsize '8k'
end

zfs 'mysql/innodb_data' do
  mountpoint node['percona']['conf']['mysqld']['innodb_data_home_dir']
  atime 'off'
  compression 'lz4'
  recordsize '16k'
end

zfs 'mysql/innodb_logs' do
  mountpoint node['percona']['conf']['mysqld']['innodb-log-group-home-dir']
  atime 'off'
  compression 'lz4'
  recordsize '128k'
end

zfs 'mysql/tmp' do
  mountpoint node['percona']['server']['tmpdir']
  atime 'off'
  compression 'lz4'
end

include_recipe 'optoro_mysql'
