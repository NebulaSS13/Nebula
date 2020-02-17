#!/bin/sh

mkdir /byond
chown $RUNAS:$RUNAS /byond /nebula nebula.rsc

gosu $RUNAS DreamDaemon nebula.dmb 8000 -trusted -verbose
