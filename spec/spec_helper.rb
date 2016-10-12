require 'childprocess'
require 'support/go_build'
require 'byebug'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "test.db"

RSpec.configure do |config|
  config.before(:all) do
    GoBuild.build('main.go')
    $child_process = ChildProcess.build('./main')
    $child_process.start
    sleep(1) # warm up
  end

  config.before(:each) do
    fail "App is down" unless $child_process.alive?
  end

  config.after(:all) do
    $child_process.stop if $child_process
    File.delete("test.db")
  end
end
