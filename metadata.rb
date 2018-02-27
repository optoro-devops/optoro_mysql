name 'optoro_mysql'
maintainer 'Optoro'
maintainer_email 'devops@optoro.com'
license 'MIT'
description 'This is a wrapper around the percona cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/optoro-devops/optoro_mysql'
issues_url 'https://github.com/optoro-devops/optoro_mysql'
version '0.0.48'

supports 'ubuntu', '= 14.04'

provides 'backup'
provides 'default'
provides 'logrotate'
provides 'users'

recipe 'default', 'Installs Percona MySQL'
recipe 'backup', 'Installs Backup scripts for MySQL'
recipe 'logrotate', 'Configures rotation of MySQL logs'
recipe 'users', 'Creates user accounts for MySQL'
recipe 'add_percona_repo', 'Adds custom percona repository'
recipe 'create_mysql_directories', 'Creates directories for mysql files'
recipe 'setup', 'Creates random passwords for mysql users'
recipe 'log_fix', 'Creates a fix for mysql log files'
recipe 'setup', 'Creates random passwords for mysql users'
recipe 'test', 'Creates test-related items for test kitchen'

depends 'users'
depends 'sudo'
depends 'percona', '~> 0.16.0'
depends 'sysctl', '= 0.7.0'
depends 'database', '~> 4.0.3'
depends 'logrotate', '~> 1.8.0'
depends 'cron', '~> 1.6.1'
depends 'apt'
depends 'openssl'
depends 'logrotate'
depends 'chef-vault'
depends 'optoro_consul'
depends 'tar'
