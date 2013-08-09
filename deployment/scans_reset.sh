#!/bin/bash
#
# Clear all the ticket scan files.
#

set -e # Bail immediately on errors.

### Guard checks ###
if [ -z "$DERRINGER_PATH" ]; then
  DERRINGER_PATH=$(eval echo -n ~${SMASHCON_USER}/derringer)
  echo "Environment variable DERRINGER_PATH not provided. Defaulting to $DERRINGER_PATH"
fi
if [ `id -u` -eq 0 ]; then
  echo "Must NOT be run as root, or via sudo."
  exit 1;
fi

### Shortcuts ###
function log() {
  echo -e "\n*** $1"
}

### Wipe them out. All of them. ###
pushd $DERRINGER_PATH
  log "Clear all the scan record dirs and files"
  rm -rfv db/scans/*
popd
