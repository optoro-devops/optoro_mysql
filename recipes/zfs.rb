#<
# This recipe adds zfs storage capabilities for mysql.
#>
include_recipe 'optoro_zfs'
include_recipe 'aws'

cookbook_file '/etc/mysql/conf.d/zfs-hack-db.cnf' do
  action :create
end

node.set['optoro_zfs']['zfs_arc_max'] = (node['memory']['total'].to_i * 0.05 * 1024).round(0).to_s
node.set['percona']['server']['innodb_data_dir'] = '/mysql/innodb_data'
node.set['percona']['server']['tmpdir'] = '/mysql/tmp'
node.set['percona']['server']['datadir'] = '/var/lib/mysql'
node.set['percona']['server']['max_allowed_packet'] = '256M'
node.set['percona']['conf']['mysqld']['innodb_use_native_aio'] = '0'
node.set['percona']['conf']['mysqld']['skip-innodb_doublewrite'] = '0'
node.set['percona']['conf']['mysqld']['innodb-log-group-home-dir'] = '/mysql/innodb_logs'
node.set['percona']['conf']['mysqld']['innodb_data_home_dir'] = '/mysql/innodb_data'

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
