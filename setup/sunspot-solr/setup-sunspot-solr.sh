#!/bin/bash
set -xeu

readonly MY_PATH=$(cd $(dirname $0) && pwd)
readonly LODGE_ROOT_PATH=$(cd $MY_PATH/../../ && pwd)
readonly EXEC='bundle exec'

# Setup for sunspot & solr.
(
  cd $LODGE_ROOT_PATH
  $EXEC rails generate sunspot_rails:install
  # Initialize solr.
  $EXEC rake sunspot:solr:start RAILS_ENV=production
  sleep 3
  $EXEC rake sunspot:reindex RAILS_ENV=production
  $EXEC rake sunspot:solr:stop RAILS_ENV=production
  # Copy production config files to `$LODGE_ROOT_PATH/solr/`.
  cp -rf $MY_PATH/production $LODGE_ROOT_PATH/solr
)
