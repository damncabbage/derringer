#!/bin/bash
#
# If I had the time, this would all be Puppet. (Or Ansible.)
#
# Idempotent; run this as many times as you want. Database imports
# are handled by the deployment/data_reset.sh script instead.
#

set -e # Bail immediately on errors.

### Guard checks ###
if [ -z "$DB_PASSWORD" ]; then
  echo "Environment variable DB_PASSWORD is required."
  exit 1;
fi
if [ -z "$BTSYNC_SECRET" ]; then
  echo "Environment variable BTSYNC_SECRET is required."
  exit 1;
fi
if [ -z "$SMASHCON_USER" ]; then
  SMASHCON_USER=smashcon
  echo "Environment variable SMASHCON_USER not provided. Defaulting to $SMASHCON_USER"
fi
if [ -z "$DERRINGER_PATH" ]; then
  DERRINGER_PATH=$(eval echo -n ~${SMASHCON_USER}/derringer)
  echo "Environment variable DERRINGER_PATH not provided. Defaulting to $DERRINGER_PATH"
fi
if [ `id -u` -gt 0 ]; then
  echo "Must be run as root, or via sudo."
  exit 1;
fi


### Shortcuts ###
function log() {
  echo -e "\n*** $1"
}
SMASHCON="sudo -u $SMASHCON_USER"
BUNDLE_EXEC="$SMASHCON RAILS_ENV=production bundle exec"
RAKE="$BUNDLE_EXEC rake"


### Start the sync ###
pushd $DERRINGER_PATH
  log "Resync codebase (assumes codebase already present)"
  $SMASHCON git fetch origin
  $SMASHCON git reset --hard origin/master

  log "Add btsync to Upstart"
  cp -fv ./deployment/etc/init/*.conf /etc/init/

  log "Remove couchdb startup job (in case it's still there)"
  update-rc.d coucbdb disable || true # Don't care if it fails; might have been disabled already.

  log "Libraries for Derringer"
  apt-get install -y libxml2 libxml2-dev libxslt1-dev

  log "Deployment bundle install"
  $SMASHCON bundle install --deployment

  log "Clearing existing assets (if any)"
  rm -rf public/assets
  $RAKE assets:precompile

  log "Environment setup"
  echo -e "DB_PASSWORD=$DB_PASSWORD\nSECRET=$BTSYNC_SECRET" | $SMASHCON tee .env

  log "BTSync configuration"
  $RAKE btsync:config --trace

  log "Kick Passenger into restarting"
  $SMASHCON touch tmp/restart.txt
popd

log "Restart BTSync (after regenerating its config earlier)"
stop derringer-btsync-1 || true # Might not be running.
start derringer-btsync-1

