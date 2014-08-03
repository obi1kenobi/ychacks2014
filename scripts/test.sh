#!/usr/bin/env bash

# stop immediately if any process returns non-zero exit code
set -e

# sanity check
if [ "$0" != "./scripts/test.sh" ]; then
  echo "Start failed: Wrong cwd"
  echo "Executed from wrong cwd, you need to be in the ychacks2014 root to call this script"
  exit 1
fi

# run build script
chmod +x ./scripts/build.sh && ./scripts/build.sh

pushd ./bin

NODE_ENV=test mocha --bail --recursive --reporter spec --ui bdd --timeout 2000 --slow 100

popd
