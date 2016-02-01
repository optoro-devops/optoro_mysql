require 'spec_helper'

describe 'MySQL Service' do
  describe service('mysql') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(3306) do
    it { should be_listening }
  end

  describe file('/etc/mysql/my.cnf') do
    it { should contain('innodb_use_native_aio = 1') }
  end

  describe file('/root/.my.cnf') do
    it { should contain('password=testing123') }
  end

  describe 'Consul Service' do
    describe port(8500) do
      it { should be_listening }
    end

    it 'registers a mysql service' do
      expect(command('curl http://localhost:8500/v1/catalog/service/mysql').stdout).to match(/mysql/)
    end

    it 'creates a health check' do
      expect(command('curl http://localhost:8500/v1/health/checks/mysql').stdout).to match(/passing/)
    end
  end
end
