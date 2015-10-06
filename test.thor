# vim: set syntax=ruby :
require 'thor'
require 'open3'

class Test < Thor
  desc "knife_test", "Execute knife cookbook test"
  def knife_test
    cookbook = Dir.pwd.split(File::SEPARATOR).last
    execute_command('bundle', 'exec', 'knife', 'cookbook', 'test', "--cookbook-path=#{ENV['COOKBOOK_PATH']}", cookbook)
  end

  desc "chefspec", "Execute chefspec tests"
  def chefspec
    execute_command('bundle', 'exec', 'rspec', '--color')
  end

  desc "foodcritic", "Execute foodcritic linting tool"
  def foodcritic
    execute_command('bundle', 'exec', 'foodcritic', '-f', 'any', '-B', './')
  end

  desc "rubocop", "Execute rubocop linting tool"
  def rubocop
    execute_command('bundle', 'exec', 'rubocop')
  end

  desc "kitchen", "Execute test-kitchen"
  def kitchen
    execute_command('bundle', 'exec', 'kitchen', 'test', '-d', 'always', '-c', '2')
  end

  private

  def execute_command(*args)
    Open3.popen3(*args) do |stdin, stdout, stderr, wait|
      stdout.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
      begin
        loop do
          IO.select([stdout])
          print stdout.read_nonblock(8)
        end
      rescue Errno::EAGAIN
        retry
      rescue EOFError
        exit 1 unless wait.value.success?
      end
    end
  end
end
