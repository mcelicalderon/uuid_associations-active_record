require 'pry'
require 'bundler/setup'
require 'uuid_associations/active_record'
require 'support/schema'
require 'support/models/team'
require 'support/models/user'
require 'support/models/post'
require 'support/models/comment'
require 'support/models/pet'
require 'support/models/toy'
require 'support/models/attachment'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
