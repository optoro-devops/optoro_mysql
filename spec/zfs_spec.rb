require 'spec_helper'

describe 'optoro_mysql::zfs' do
  Resources::PLATFORMS.each do |platform, value|
    value['versions'].each do |version|
      context "On #{platform} #{version}" do
        include_context 'optoro_mysql'

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version, log_level: :error) do |node|
            node.set['lsb']['codename'] = value['codename']
          end.converge(described_recipe)
        end

        %w(
          optoro_zfs
          aws
        ).each do |r|
          it "should include the #{r} recipe" do
            expect(chef_run).to include_recipe(r)
          end
        end

        it 'should create the zfs-hack-db.cnf file' do
          expect(chef_run).to create_cookbook_file('/etc/mysql/conf.d/zfs-hack-db.cnf')
        end

        # aws stuff
        it 'should create the zfs_zil volume' do
          expect(chef_run).to create_aws_ebs_volume('zfs_zil').with(size: 20, device: '/dev/sdi', volume_type: 'io1')
        end

        it 'should attach the zfs_zil volume' do
          expect(chef_run).to attach_aws_ebs_volume('zfs_zil').with(size: 20, device: '/dev/sdi', volume_type: 'io1')
        end

        it 'should create the zfs_cache volume' do
          expect(chef_run).to create_aws_ebs_volume('zfs_cache').with(size: 20, device: '/dev/sdg', volume_type: 'gp2')
        end

        it 'should attach the zfs_cache volume' do
          expect(chef_run).to attach_aws_ebs_volume('zfs_cache').with(size: 20, device: '/dev/sdg', volume_type: 'gp2')
        end

        it 'should create the zfs_data volume' do
          expect(chef_run).to create_aws_ebs_volume('zfs_data').with(size: 250, device: '/dev/sdh')
        end

        it 'should attach the zfs_data volume' do
          expect(chef_run).to attach_aws_ebs_volume('zfs_data').with(size: 250, device: '/dev/sdh')
        end

        # zfs stuff
        it 'should create the mysql zpool' do
          expect(chef_run).to create_zpool('mysql').with(disks: ['/dev/xvdh'], log_disks: ['/dev/xvdi'], cache_disks: ['/dev/xvdg'], mountpoint: 'none', force: true)
        end

        it 'should create mysql/mysql' do
          expect(chef_run).to create_optoro_zfs('mysql/mysql').with(mountpoint: '/var/lib/mysql', atime: 'off', compression: 'lz4', recordsize: '8k')
        end

        it 'should create mysql/innodb_data' do
          expect(chef_run).to create_optoro_zfs('mysql/innodb_data').with(mountpoint: '/mysql/innodb_data', atime: 'off', compression: 'lz4', recordsize: '16k')
        end

        it 'should create mysql/innodb_logs' do
          expect(chef_run).to create_optoro_zfs('mysql/innodb_logs').with(mountpoint: '/mysql/innodb_logs', atime: 'off', compression: 'lz4', recordsize: '128k')
        end

        it 'should create mysql/tmp' do
          expect(chef_run).to create_optoro_zfs('mysql/tmp').with(mountpoint: '/mysql/tmp', atime: 'off', compression: 'lz4')
        end
      end
    end
  end
end
