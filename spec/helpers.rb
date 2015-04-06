shared_context 'optoro_mysql' do
  before do
    stub_command('test -f /var/lib/mysql/mysql/user.frm').and_return(0)
    stub_command('test -f /etc/mysql/grants.sql').and_return(0)
    stub_command('test -f /var/optoro/lib/mysql/user.frm').and_return(0)
    stub_command("mysqladmin --user=root --password='' version").and_return(0)

    @rest = mock("Chef::REST")
    Chef::REST.stub!(:new).and_return(@rest)
    allow(Chef::EncryptedDataBagItem).to receive(:load_secret).and_return('testsecret')
    expect(Chef::DataBagItem).to receive(:save).and_return(true)
    allow(Chef::DataBagItem).to receive(:save).and_return(true)
    allow(Chef::DataBagItem).to receive(:save).and_return(true)

    allow(File).to receive(:size).and_call_original
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/lib/mysql/ib_logfile0').and_return(true)
    allow(File).to receive(:exist?).with('/var/lib/mysql/ib_logfile1').and_return(true)
    allow(File).to receive(:size).with('/var/lib/mysql/ib_logfile0').and_return(5)
    allow(File).to receive(:size).with('/var/lib/mysql/ib_logfile1').and_return(5)

    allow(Chef::EncryptedDataBagItem).to receive(:load).and_call_original
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
