#!/usr/bin/env bash

# stop immediately if any process returns non-zero exit code
set -e

# sanity check:
# this script deletes files left and right
# make sure that it's deleting the right ones
if [ "$0" != "./scripts/build.sh" ]; then
  echo "Build failed: Wrong cwd"
  echo "Executed from wrong cwd, you need to be in the ychacks2014 root to call this script"
  exit 1
fi

echo "Removing existing build..."
rm -rf ./bin && mkdir ./bin
cp -r ./src/public ./bin/public
cp -r ./src/views  ./bin/views
mkdir -p ./bin/lib/client
cp -r ./src/lib/client/scripts ./bin/lib/client/scripts
chmod -R +x ./bin/lib/client/scripts
mkdir ./bin/routes

# compile with source maps
echo "Compiling Coffeescript to JS..."
./node_modules/.bin/coffee --map --output ./bin/ --compile ./src/

echo "Linting..."
find ./src -name "*.coffee" -print0 | xargs -0 ./node_modules/.bin/coffeelint -f ./coffeelint.json

echo "Build successful!"
