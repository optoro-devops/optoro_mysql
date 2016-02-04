module Overcommit
  module Hook
    module PreCommit
      # Run food critic to lint commit
      class CookbookVersion < Base
        def run
          begin
            require 'chef/cookbook/metadata'
          rescue LoadError
            return :stop, 'run `bundle install` to install the chef gem'
          end

          metadata = Chef::Cookbook::Metadata.new
          metadata.from_file('metadata.rb')

          current_version = metadata.version

          return :fail, "Cookbook version #{current_version} already exists." if tag_exists? current_version

          :pass
        end

        def tag_exists?(version)
          begin
            require 'git'
          rescue LoadError
            return :stop, 'run `bundle install` to install the git gem'
          end
          Git.open(::Dir.pwd).tags.map { |tag| tag.name.delete('v') }.include? version
        end
      end
    end
  end
end
