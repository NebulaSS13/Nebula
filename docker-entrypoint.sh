#!/bin/sh

mkdir /byond
chown $RUNAS:$RUNAS /byond /scav scavstation.rsc

gosu $RUNAS DreamDaemon scavstation.dmb 8000 -trusted -verbose
