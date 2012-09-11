# Derringer

The mobile companion to SMASH!'s online ticket sales system.


## Setup

### Requirements

You need the following installed:

* Git
* Ruby 1.9.2+
* Bundler
* MySQL 5.1+
* CouchDB 1.2+
* Babushka 0.13+

To bootstrap Babushka, use:

```
sudo bash -c "`curl https://babushka.me/up`"
```

### Configuration

Create the configuration files from the defaults with the following:

```
bundle exec padrino rake dev:config_files
```

(You'll need to change the default username, password, etc.)


### MySQL

To set up the database structure, use:

```
bundle exec padrino rake ar:create
bundle exec padrino rake ar:migrate # There are bugs in Padrino that prevent us from using a schema.sql
```


### CouchDB

**TODO:** This is still a bit clumsy; all these were written before CouchREST::Model was introduced, and need to start using it directly instead of making manual `Net::HTTP` calls with the library in `lib/couch/server.rb'.

```
# Set up the databases and permissions.
bundle exec padrino rake couchdb:init:admin[exampleusername,apassword]
bundle exec padrino rake couchdb:init:db[exampleusername,apassword]
```

To set up replication, use the following to set up replication to one or more machines (this will need to be run every time the service is started, and will need to be run from each machine with the full hosts list):

```
bundle exec rake couchdb:init:replication[exampleusername,apassword] hosts="192.168.2.1,192.168.2.2,..."
```

### Development

Derringer uses Compass for its CSS. While developing, use `bundle exec compass watch` to generate CSS from the Sass in `public/scss/`.

**TODO:** Seed data for development, to be loaded in with `bundle exec padrino rake ar:seed`.


### Production

To set up the Ruby environment for production (with Git, RVM, Bundler), use:

```
babushka production_prepare
```

Data dumps from production can be loaded in with a Babushka script:

```
PADRINO_ENV=production bundle exec babushka import
```

**TODO:** nginx / unicorn setup.
