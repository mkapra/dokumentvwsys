#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /src/tmp/pids/server.pid

# Database migration
bundle exec rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle exec rails s -b 0.0.0.0
