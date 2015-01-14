require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start!

require File.expand_path('../resources.rb', __FILE__)
require File.expand_path('../helpers.rb', __FILE__)
require File.expand_path('../matchers.rb', __FILE__)
