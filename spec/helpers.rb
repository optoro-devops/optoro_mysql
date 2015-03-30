shared_context 'optoro_mysql' do
  before do
    stub_command('test -f /var/lib/mysql/mysql/user.frm').and_return(0)
    stub_command('test -f /etc/mysql/grants.sql').and_return(0)
    stub_command('test -f /var/optoro/lib/mysql/user.frm').and_return(0)
    stub_command("mysqladmin --user=root --password='' version").and_return(0)

    allow(File).to receive(:size).and_call_original
    allow(File).to receive(:size).with('/var/lib/mysql/ib_logfile0').and_return(5)
    allow(File).to receive(:size).with('/var/lib/mysql/ib_logfile1').and_return(5)

    allow(Chef::EncryptedDataBagItem).to receive(:load).and_call_original
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('passwords', 'mysql').and_return('root' => 'test')

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('mysql', 'optiturn').and_return(
      'database_name' => 'inventory_production',
      'host' => '%',
      'mysql_permissions' => ['all'],
      'name' => 'optiturn',
      'password' => 'test'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('mysql', 'monitor').and_return(
      'database_name' => '*',
      'host' => '%',
      'mysql_permissions' => ['Select'],
      'name' => 'monitor',
      'password' => 'test'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('mysql', 'optiturn_local').and_return(
      'database_name' => 'inventory_production',
      'host' => 'localhost',
      'mysql_permissions' => ['all'],
      'name' => 'optiturn',
      'password' => 'test'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('mysql', 'spexy').and_return(
      'database_name' => 'spexplus',
      'host' => '%',
      'mysql_permissions' => [
        'insert',
        'update',
        'delete',
        'create',
        'drop',
        'references',
        'index',
        'alter',
        'create temporary tables',
        'lock tables',
        'create view',
        'show view',
        'create routine',
        'alter routine',
        'execute',
        'event',
        'trigger'
      ],
      'name' => 'spexy',
      'password' => 'test'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('mysql', 'link').and_return(
      'database_name' => 'inventory_production',
      'host' => '%',
      'mysql_permissions' => ['Select'],
      'name' => 'link',
      'password' => 'test'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('mysql', 'repl').and_return(
      'database_name' => '*',
      'host' => '%',
      'mysql_permissions' => ['replication slave'],
      'name' => 'repl',
      'password' => 'test'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with('mysql', 'vividcortex').and_return(
      'database_name' => '*',
      'host' => 'localhost',
      'mysql_permissions' => %w( process select ),
      'name' => 'vividcortex',
      'password' => 'test'
    )
  end
end
