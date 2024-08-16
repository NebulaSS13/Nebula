#!/bin/sh
TIMESTAMP=$( date "+%H_%d_%m_%Y" )
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WRITE_DIR="$1"
if [ -z "${WRITE_DIR-}" ]; then
  WRITE_DIR="/tmp"
fi
zip $WRITE_DIR/ss13_saves_$TIMESTAMP.zip $SCRIPT_DIR/../data/player_saves
zip $WRITE_DIR/ss13_charinfo_$TIMESTAMP.zip $SCRIPT_DIR/../data/character_info
