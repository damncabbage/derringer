PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'database_cleaner'
require 'capybara/rspec'

def app
  Derringer.tap {|app| }
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(Padrino.root, 'spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.include Rack::Test::Methods

  # CouchDB Test DB Setup
  config.before(:each) do
    Scan.database.recreate! rescue nil
    Thread.current[:couchrest_design_cache] = {}
  end

  # DB Cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Requests
  Capybara.app = app
end

# FactoryGirl models
FactoryGirl.definition_file_paths = [
  File.join(Padrino.root, 'factories'),
  File.join(Padrino.root, 'test', 'factories'),
  File.join(Padrino.root, 'spec', 'factories')
]
FactoryGirl.find_definitions
