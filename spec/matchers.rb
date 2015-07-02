if defined?(ChefSpec)
  def use_sysctl_param(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sysctl_param, :apply, resource_name)
  end

  def create_mysql_database_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_database_user, :create, resource_name)
  end

  def grant_mysql_database_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_database_user, :grant, resource_name)
  end

  def create_optoro_zfs(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:optoro_zfs, :create, resource_name)
  end
end
