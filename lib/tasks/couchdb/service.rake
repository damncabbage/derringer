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
    end
  end

  desc "Kills the local CouchDB instance."
  task :stop do
    if linux?
      puts `couchdb/bin/couchdb -k`
    elsif mac?
      `launchctl stop org.apache.couchdb`
    end
  end

end
