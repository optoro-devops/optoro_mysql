shared_context 'optoro_mysql' do
  before do
    stub_command('test -f /var/lib/mysql/mysql/user.frm').and_return(0)
    stub_command('test -f /etc/mysql/grants.sql').and_return(0)
    stub_command('test -f /var/optoro/lib/mysql/user.frm').and_return(0)
    stub_command("mysqladmin --user=root --password='' version").and_return(0)

    # Enable why run so that Chef doesn't try to communicate with a Chef server 
    # during data bag creation/load.
    Chef::Config[:why_run] = true
    allow(Chef::EncryptedDataBagItem).to receive(:load_secret).and_return('testsecret')

    allow(File).to receive(:size).and_call_original
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/lib/mysql/ib_logfile0').and_return(true)
    allow(File).to receive(:exist?).with('/var/lib/mysql/ib_logfile1').and_return(true)
    allow(File).to receive(:size).with('/var/lib/mysql/ib_logfile0').and_return(5)
    allow(File).to receive(:size).with('/var/lib/mysql/ib_logfile1').and_return(5)

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('passwords', 'mysql').and_return(
      'id' => 'mysql',
      'root' => 'test',
      'optiturn' => {
        'database_name' => 'inventory_production',
        'host' => '%',
        'mysql_permissions' => ['all'],
        'name' => 'optiturn'
      },
      'monitor' => {
        'database_name' => '*',
        'host' => '%',
        'name' => 'monitor',
        'mysql_permissions' => ['Select']
      }
    )
  end
end
