# Derringer [![Build Status](https://travis-ci.org/damncabbage/derringer.png)](https://travis-ci.org/damncabbage/derringer)

The mobile companion to SMASH!'s online ticket sales system.

![eMachine + Laser Barcode Scanner + Bollards => 3000 people in an auditorium.](http://dl.dropbox.com/u/5687497/Derringer%20Equipment.png)


## Setup

### Requirements

You need the following installed:

* Git
* Ruby 1.9.3+
* Bundler
* MySQL 5.1+

... And to synchronise with other nodes:

* BTSync 1.0+ (provided in the repo under `bin/...`)


### Environment

In development, Derringer will run straight off the bat. In production, the following environment variables can be set:

* `DB_NAME` (defaults to "derringer")
* `DB_USERNAME` (defaults to "smashcon")
* `DB_PASSWORD` (required)

You can set these with a `.env` file; a `.env-example` file is provided as a template.


### MySQL

To set up the database structure, use:

```
bundle exec rake db:reset
```


### BTSync


BTSync config files aren't dynamic; you need to generate it for your install with a rake task, providing the generated secret as an environment variable, eg.

```
BTSYNC_SECRET=`bundle exec rake btsync:secret` # Secret that is shared across all machines
bundle exec rake btsync:config SECRET="$BTSYNC_SECRET"
```

### Deployment

Three scripts are provided in the `deployment` folder: `sync.sh` (which runs as a Puppet-like script that installs and configures everything, and can be run over and over to keep everything up to date), `db_reset.sh` (which drops the database and recreates it from a dump), and `scans_reset.sh` (clears all the ticket scans).

Also, `sync.sh` needs to be run as root because I'm a terrible person.

```
sudo BTSYNC_SECRET=SeeTheBTSyncSectionAbove DB_PASSWORD=yolochangethis ~/derringer/deployment/sync.sh
CHIKI_DUMP_PATH=tmp/chiki.sql ~/derringer/deployment/db_reset.sh
~/derringer/deployment/scans_reset.sh
```
