# Platforms to test our code against
# Also includes variables for platform specific values
# that can be called in ChefSpec tests
module Resources
  PLATFORMS = {
    'ubuntu' => {
      'pkg_manager' => 'apt',
      'versions'    => ['14.04'],
      'codename'    => 'trusty'
    }
  }
end
