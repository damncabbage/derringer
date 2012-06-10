require 'uri'
require 'net/http'
require 'json'
require 'socket'

namespace :couchdb do
  namespace :db do

    def port
      5984
    end
    def local_server(username=nil, password=nil)
      @local_server = Couch::Server.new("127.0.0.1", port, username, password)
    end
    def remote_server(host, username=nil, password=nil)
      Couch::Server.new(host, port, username, password)
    end
    def my_first_non_loopback_ipv4
      addr = Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast?}
      addr.ip_address if addr
    end


    desc "Creates the admin user for cross-db communication."
    task :admin, :username, :password do |t, args|
      raise "Must provide username and password as arguments, eg. rake couchdb:init:admin[foobar,passworbaz]" unless args[:username] && args[:password]

      response = local_server.put("/_config/admins/#{args[:username]}", args[:password].inspect)
      if response.code.to_i == 200
        puts "Added user #{args[:username]}"
      end
    end

    desc "Creates the databases."
    task :create, :username, :password do |t, args|
      raise "Must provide username and password as arguments, eg. rake couchdb:init:admin[foobar,passworbaz]" unless args[:username] && args[:password]

      errors = []
      %w(orders scans).each do |db|
        begin
          response = local_server(args[:username], args[:password]).put("/#{db}", "")
          puts "Added database #{db}"
        rescue Exception => e
          errors.push e
        end
      end
      raise errors.map(&:message).join("\n")
    end


    desc "Sets up replication between CouchDB nodes."
    task :replication, :username, :password do |t, args|
      raise "Must provide username, password and host list as arguments, eg. rake couchdb:init:replication[foobar,passworbaz] hosts=192.168.2.1,192.168.2.2,..." unless args[:username] && args[:password] && ENV['hosts']

      db = 'scans'
      ip_list = ENV['hosts'].split(/[;, ]/)

      # Make sure we're not in the host list. Get our IP first.
      my_ip = my_first_non_loopback_ipv4
      ip_list.reject! { |ip| ip == my_ip }

      ip_list.each do |ip|

        rs = remote_server(ip, args[:username], args[:password])
        response = rs.post("/_replicate", {
          :source => "http://#{ip}:#{port}/#{db}",
          :target => URI::HTTP.build(
            :host => '127.0.0.1', :port => port, :path => "/#{db}",
            :userinfo => "#{args[:username]}:#{args[:password]}"
          ),
          :continuous => true
        }.to_json)

        if response.code.to_i == 200
          puts "Replication from #{ip} established."
        end
      end
    end

    # Seed the database
    namespace :seed do
      desc "Loads in a fake Orders and Scans dataset for development and testing."
      task :fake, :username, :password do
        raise "TODO"
      end
    end
    desc "Loads in a database seed from a file."
    task :seed, :username, :password, :source do
      raise "TODO"
    end

  end
end
