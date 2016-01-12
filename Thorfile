# vim: set syntax=ruby :
require 'thor'

# Test class
class Test < Thor
  include Thor::Actions

  def self.exit_on_failure?
    true
  end

  desc 'chefspec', 'Execute chefspec tests'
  def chefspec
    execute_command('bundle exec rspec --color --require spec_helper spec/')
  end

  desc 'foodcritic', 'Execute foodcritic linting tool'
  def foodcritic
    execute_command('bundle exec foodcritic -f any -B ./ -G')
  end

  desc 'rubocop', 'Execute rubocop linting tool'
  def rubocop
    execute_command('bundle exec rubocop')
  end

  desc 'kitchen', 'Execute test-kitchen'
  def kitchen
    execute_command('bundle exec kitchen test -d always -c 2')
  end

  desc 'test', 'Execute all tests'
  def test
    foodcritic
    rubocop
    chefspec
    kitchen
    puts 'Thor marked build OK'
  end

  private

  def execute_command(command)
    r = run(command)
    if r
      puts "#{caller_locations(1, 1)[0].label}   SUCCESS!"
    else
      puts "#{caller_locations(1, 1)[0].label}   FAILED!"
      exit 1
    end
  end
end
