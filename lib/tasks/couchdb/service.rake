require File.expand_path('../../rake_helpers/os', File.dirname(__FILE__))
include RakeHelpers::OS

# CouchDB
namespace :couchdb do

  desc "Starts CouchDB in background mode."
  task :start do
    if linux?
      fork do
        puts `couchdb/bin/couchdb -b`
      end
    elsif mac?
      `launchctl start org.apache.couchdb`
      puts "Started CouchDB." if $?.success?
    end
  end

  desc "Kills the local CouchDB instance."
  task :stop do
    if linux?
      puts `couchdb/bin/couchdb -k`
    elsif mac?
      `launchctl stop org.apache.couchdb`
      puts "Stopped CouchDB." if $?.success?
    end
  end

end
