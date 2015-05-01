
#<
# This recipe adds logrotate functionality for the mysql slow log
#>
logrotate_app 'mysql-slow' do
  frequency 'daily'
  path '/var/optoro/log/mysql/mysql-slow.log'
  rotate '6'
  options %w( missingok compress delaycompress dateext )
  template_mode '0644'
  postrotate ['/usr/bin/mysql -e \'select @@global.long_query_time into @lqt_save; set global long_query_time=2000; select sleep(2); FLUSH LOGS; select sleep(2); set global long_query_time=@lqt_save;\'']
end
