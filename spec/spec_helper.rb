require 'childprocess'
require 'support/go_build'
require 'byebug'
require 'active_record'
require 'database_cleaner'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "test.db"

RSpec.configure do |config|
  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)

    GoBuild.build('main.go')
    $child_process = ChildProcess.build('./main')
    $child_process.start
    sleep(1) # warm up
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:each) do
    fail "App is down" unless $child_process.alive?
  end

  config.after(:all) do
    $child_process.stop if $child_process
    DatabaseCleaner.clean
  end
end
