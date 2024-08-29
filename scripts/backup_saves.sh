#!/bin/sh
# This script requires a git repository initialized
# in data/ with an upstream remote configured. 
TIMESTAMP=$( date "+%H_%d_%m_%Y" )
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/../data
git add *
git commit -m "Data backup $TIMESTAMP"
git push upstream master

