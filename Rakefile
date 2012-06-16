require 'rubygems'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
rescue Exception => e
  $stderr.puts e.message
  $stderr.puts "Run `gem install bundler` to install Bundler if necessary."
  exit e.status_code
end
require 'rake'

# Libraries and Tasks
Dir[File.dirname(__FILE__) + "/lib/**/*.rb"].each { |f| require f }
Dir[File.dirname(__FILE__) + "/lib/tasks/**/*.rake"].each { |f| import f }
