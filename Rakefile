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

# Helpers
def linux?
  @linux ||= (`uname -a | grep -ic linux`.to_i > 0)
end
def mac?
  @mac ||= !linux? && (`uname -a | grep -ic darwin`.to_i > 0)
end

# Libraries and Tasks
Dir[File.dirname(__FILE__) + "/lib/**/*.rb"].each { |f| require f }
Dir[File.dirname(__FILE__) + "/lib/tasks/**/*.rake"].each { |f| import f }
