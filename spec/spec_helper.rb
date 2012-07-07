PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'database_cleaner'

def app
  Derringer.tap { |app|  }
end

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
end

# FactoryGirl models
#Dir[File.dirname(__FILE__) + '/factories/**/*.rb'].each { |f| require f }
FactoryGirl.definition_file_paths = [
  File.join(Padrino.root, 'factories'),
  File.join(Padrino.root, 'test', 'factories'),
  File.join(Padrino.root, 'spec', 'factories')
]
FactoryGirl.find_definitions
