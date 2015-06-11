source 'https://rubygems.org'
source 'http://geminabox.optoro.io'

gem 'berkshelf', '~> 3.2.1'

group :integration do
  gem 'test-kitchen', '~> 1.3.0'
  gem 'kitchen-ec2', :github => 'test-kitchen/kitchen-ec2', :ref => '0a378d5'
  gem 'kitchen-docker', '~> 1.5.0'
  gem 'kitchen-vagrant', :git => 'git@github.com:test-kitchen/kitchen-vagrant.git', :ref => 'aa3ff9'
end

group :development do
  gem 'overcommit'
  gem 'guard',  '~> 2.8.0'
  gem 'guard-kitchen', '~> 0.0.2'
  gem 'guard-rubocop',  '~> 1.2.0'
  gem 'guard-rspec',  '~> 4.3.0'
  gem 'guard-foodcritic',  '~> 1.0.3'
  gem 'guard-bundler',  '~> 2.0.0'
  gem 'chef-zero', '~> 2.2.1'
  gem 'foodcritic', '~> 4.0.0'
  gem 'foodcritic-rules-optoro'
  gem 'chefspec', '~> 4.2.0'
  gem 'rspec', '~> 3.1.0'
  gem 'strainer', '~> 3.4.0'
  gem 'rubocop', '~> 0.27.1'
  gem 'knife-solo', '0.4.2'
  gem 'knife-solo_data_bag', '1.1.0'
  gem 'aws-sdk'
  gem 'knife-cookbook-doc'
end
