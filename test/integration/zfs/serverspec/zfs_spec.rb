require 'spec_helper'

describe file('/etc/mysql/conf.d/db.cnf') do
  it { should contain('skip-innodb_doublewrite') }
end
