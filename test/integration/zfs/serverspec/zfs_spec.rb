require 'spec_helper'

describe file('/etc/mysql/my.cnf') do
  it { should contain('innodb_use_native_aio = 0') }
end
