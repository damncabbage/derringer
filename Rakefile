begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
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
def my_first_non_loopback_ipv4
  addr = Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast?}
  addr.ip_address if addr
end

# Libraries and Tasks
Dir["lib/**/*.rb"].each { |f| require f }
Dir["lib/tasks/**/*.rake"].each { |f| require f }
