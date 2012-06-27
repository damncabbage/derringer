# Derringer

The mobile companion to [Booth](https://github.com/smashcon/booth), SMASH!'s online ticket sales system.


## Installation

First really dumb requirement: make sure you have git (either `brew install git` or `sudo apt-get install git-core`).

### Babushka

This is the tool that you use to set up everything else (ruby, couchdb, mysql, databases, replication, etc).

To install it, use:

```
sudo bash -c "`curl https://babushka.me/up`"
```


### Ruby

Install Ruby 1.9.2+ with either [rbenv](https://github.com/sstephenson/rbenv) or [RVM](http://rvm.io). Set up your gems with the following:

```
gem install bundler
bundle install
```

### CouchDB

Now you have Ruby, you can use Rake to install couchdb:

```
# Get the server up.
bundle exec rake couchdb:install   # Now go for a coffee; this is going to take a while.
bundle exec rake couchdb:start

# Set up the databases and permissions.
bundle exec rake couchdb:init:admin[exampleusername,apassword]
bundle exec rake couchdb:init:db[exampleusername,apassword
```

If this is a real system, then you'll be after the real dataset. For mucking around, load in the fake dataset instead:

```
bundle exec rake couchdb:init:seed:fake[exampleusername,apassword] # TODO
```

If you're testing replication, use the following to set up replication to one or more machines (this will need to be run every time the service is started, and will need to be run from each machine with the full hosts list):

```
bundle exec rake couchdb:init:replication[exampleusername,apassword] hosts="192.168.2.1,192.168.2.2,..." # TODO
```


## Development

Install `node` (via either `brew install node` or [this set of steps](https://github.com/joyent/node/wiki/Installation)), and then `npm` (via `curl http://npmjs.org/install.sh | sudo sh`). Install the required Javascript packages with the following:

```
sudo npm install -g coffee-script
```

This will let you make changes to the `.coffee` files and have them automatically compile in the background every time you save. Run the following in a terminal in the background somewhere:

```
# This will not produce any output. It just silently looks
# for any scss/*.scss or coffee/*.coffee changes, and compiles
# them to their CSS or JS output files respectively.

be rake watch
```

Now change something in `scss` or `coffee` and watch the spooky magic happen.
