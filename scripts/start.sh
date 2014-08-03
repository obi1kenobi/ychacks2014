#!/usr/bin/env bash

# stop immediately if any process returns non-zero exit code
set -e

# sanity check
if [ "$0" != "./scripts/start.sh" ]; then
  echo "Start failed: Wrong cwd"
  echo "Executed from wrong cwd, you need to be in the ychacks2014 root to call this script"
  exit 1
fi

# run build script
chmod +x ./scripts/build.sh && ./scripts/build.sh

if [ "$NODE_ENV" == "" ]; then
  NODE_ENV="local"
fi

echo "Starting $NODE_ENV configuration..."
echo ""

env "NODE_ENV=$NODE_ENV" node ./bin/index.js &
env "NODE_ENV=$NODE_ENV" node ./bin/lib/index.js
