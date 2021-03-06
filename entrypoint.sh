#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /cafeapp/tmp/pids/server.pid

# デプロイ初回のみ
# bundle exec rails db:migrate RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
