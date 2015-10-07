require 'spec_helper'

describe 'optoro_mysql::default' do
  Resources::PLATFORMS.each do |platform, value|
    value['versions'].each do |version|
      context "On #{platform} #{version}" do
        include_context 'optoro_mysql'

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version, log_level: :error) do |node|
            node.set['lsb']['codename'] = value['codename']
          end.converge(described_recipe)
        end

        %w( libmysqlclient-dev build-essential ).each do |p|
          it "installs the #{p} package" do
            expect(chef_run).to install_package p
          end
        end

        %w(
          sysctl::default
          optoro_mysql::setup
          percona::server
          percona::toolkit
          percona::backup
          optoro_mysql::users
          optoro_mysql::backup
          optoro_mysql::logrotate
          optoro_mysql::log_fix
        ).each do |recipe|
          it "includes the #{recipe} recipe" do
            expect(chef_run).to include_recipe recipe
          end
        end

        it 'sets the vm.swappiness to 0' do
          expect(chef_run).to use_sysctl_param('vm.swappiness').with('value' => 0)
        end

        it 'create the /var/optoro' do
          expect(chef_run).to create_directory('/var/optoro')
        end

        it 'installs the backup chef_gem' do
          expect(chef_run).to install_chef_gem('backup')
        end

        it 'create the /var/optoro/backup directory' do
          expect(chef_run).to create_directory('/var/optoro/backup')
        end

        it 'create the backup script' do
          expect(chef_run).to create_cookbook_file('/var/optoro/backup/backup2.sh')
        end

        it 'creates the backup cron job' do
          expect(chef_run).to create_cron('backup-cron-job')
        end

        it 'installs the mysql2 gem' do
          expect(chef_run).to install_chef_gem 'mysql2'
        end

        it 'creates the innodb_log_group_home directory' do
          expect(chef_run).to create_directory('/var/lib/mysql').with(
            'owner' => 'mysql',
            'group' => 'mysql',
            'mode' => '0700'
          )
        end

        it 'creates the innodb_data_home_dir directory' do
          expect(chef_run).to create_directory('/var/lib/mysql').with(
            'owner' => 'mysql',
            'group' => 'mysql',
            'mode' => '0700'
          )
        end

        it 'should run fix innodb_log-file-size and notify innodb-log-file-size first run ruby block' do
          expect(chef_run).to run_bash('fix innodb-log-file-size')
          resource = chef_run.bash('fix innodb-log-file-size')
          expect(resource).to notify('ruby_block[innodb-log-file-size first run]').to(:run).immediately
        end

        # make sure default action is set to nothing
        it 'should not run the innodb-log-file-size first run ruby block by default' do
          expect(chef_run).to_not run_ruby_block('innodb-log-file-size first run')
        end

        it 'should remove anonymous mysql users' do
          expect(chef_run).to run_execute('remove anonymous user')
        end

        # in our test databag we have the optiturn and monitor users set up, so we will test for those two
        it 'should create/grant the optiturn database user' do
          expect(chef_run).to create_mysql_database_user('optiturn')
          expect(chef_run).to grant_mysql_database_user('optiturn')
        end

        it 'should create/grant the monitor database user' do
          expect(chef_run).to create_mysql_database_user('monitor')
          expect(chef_run).to grant_mysql_database_user('monitor')
        end

      end
    end
  end
end
