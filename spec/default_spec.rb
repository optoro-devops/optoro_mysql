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
      end
    end
  end
end
