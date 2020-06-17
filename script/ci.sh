#!/bin/sh
#
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ "$NODE_ENV" != "ci" ]; then
  echo "Error: Script can only be ran in an continuous integration environment"
  exit 1
fi

# Load nvm
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"

# Fail on any error.
set -e

# Test on Node.js 10.18.0
echo "Running tests on Node 10.18.0"
rm -rf node_modules yarn.lock package-lock.json
nvm install 10.18.0
nvm use 10.18.0
npm i -g yarn

# Actual build
yarn
yarn ci
# only check coverage for 10.18.0
sh script/coverage.sh
# only generate docs using 10.18.0
yarn docs

# Test on Node.js 12
echo "Running tests on Node 12"
rm -rf node_modules yarn.lock package-lock.json
nvm install 12
nvm use 12
npm i -g yarn

# Actual build
yarn
yarn ci
