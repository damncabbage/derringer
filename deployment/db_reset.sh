#!/bin/bash
#
# Drop and reimport the databases from the Chiki SQL dump (obtained
# separately and put in $CHIKI_DUMP_PATH for processing).
#

set -e # Bail immediately on errors.

### Guard checks ###
if [ -z "$DERRINGER_PATH" ]; then
  DERRINGER_PATH=$(eval echo -n ~${SMASHCON_USER}/derringer)
  echo "Environment variable DERRINGER_PATH not provided. Defaulting to $DERRINGER_PATH"
fi
if [ -z "$CHIKI_DUMP_PATH" ]; then
  CHIKI_DUMP_PATH="${DERRINGER_PATH}/tmp/chiki.sql"
  echo "Environment variable CHIKI_DUMP_PATH not provided. Defaulting to $CHIKI_DUMP_PATH"
fi
if [ -z "$RAILS_ENV" ]; then
  export RAILS_ENV=production
fi
if [ `id -u` -eq 0 ]; then
  echo "Must NOT be run as root, or via sudo."
  exit 1;
fi


### Shortcuts ###
function log() {
  echo -e "\n*** $1"
}
BUNDLE_EXEC="bundle exec"
RAKE="$BUNDLE_EXEC rake"
DB="$BUNDLE_EXEC rails db -p"

### Start the reimport ###
pushd $DERRINGER_PATH
  log "Drop and re-create the import database"
  echo 'DROP DATABASE IF EXISTS chiki; CREATE DATABASE chiki' | $DB

  log "Import the dump into the temp DB (chiki)"
  if [ ! -f "$CHIKI_DUMP_PATH" ]; then
    echo "Dump can't be found at '$CHIKI_DUMP_PATH'!"
    exit 1
  fi
  $RAKE smashcon:db:import_chiki_dump[$CHIKI_DUMP_PATH,chiki]

  log "Reset the Derringer database"
  $RAKE db:reset # Drops, creates, migrates, runs seeds.

  log "Convert the chiki database to something Derringer can understand"
  $RAKE smashcon:db:convert_from_chiki[chiki]
popd
