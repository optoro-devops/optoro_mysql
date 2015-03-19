name 'optoro_mysql'
maintainer 'Optoro'
maintainer 'devops@optoro.com'
license 'MIT'
description 'This is a wrapper around the percona cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.2'

depends 'percona', '~> 0.16.0'
depends 'sysctl', '~> 0.6.2'
depends 'database', '~> 4.0.3'
depends 'logrotate', '~> 1.9.0'
depends 'cron', '~> 1.6.1'
