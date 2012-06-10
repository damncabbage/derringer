# CouchDB
namespace :couchdb do

  desc "Installs CouchDB#{(linux? ? " to couchdb/" : "")}."
  task :install do
    if linux?
      `mkdir -p tmp couchdb &&
         cd tmp &&
         if [ -d build-couchdb ]; then
           cd build-couchdb && git pull
         else
           git clone https://github.com/iriscouch/build-couchdb && cd build-couchdb
         fi
       sudo apt-get install make gcc zlib1g-dev libssl-dev &&
         git submodule init &&
         git submodule update &&
         rake install=$(pwd)/../../couchdb &&
         sed -ie 's/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/' $(pwd)/../../couchdb/etc/couchdb/local.ini`
    elsif mac?
      `brew install couchdb &&
         sed -ie 's/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/' $(pwd)/../../couchdb/etc/couchdb/local.ini &&
         mkdir -p ~/Library/LaunchAgents &&
         cp /usr/local/Cellar/couchdb/1.*/Library/LaunchDaemons/org.apache.couchdb.plist ~/Library/LaunchAgents/ &&
         launchctl load -w ~/Library/LaunchAgents/org.apache.couchdb.plist`
    end
  end

end
