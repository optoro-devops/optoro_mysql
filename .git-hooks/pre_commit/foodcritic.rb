module Overcommit
  module Hook
    module PreCommit
      # Run food critic to lint commit
      class Foodcritic < Base
        def run
          begin
            require 'foodcritic'
          rescue LoadError
            return :stop, 'run `bundle install` to install the foodcritic gem'
          end

          review = ::FoodCritic::Linter.new.check cookbook_paths: `git rev-parse --show-toplevel`.tr("\n", '')
          [(review.warnings.empty? ? :pass : :fail), review.to_s]
        end
      end
    end
  end
end
