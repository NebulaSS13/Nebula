#!/bin/bash

set -o pipefail

dmepath=""
retval=1

for var; do
    if [[ $var != -* && $var == *.dme ]]; then
        dmepath=$(echo $var | sed -r 's/.{4}$//')
        break
    fi
done

if [[ $dmepath == "" ]]; then
    echo "No .dme file specified, aborting."
    exit 1
fi

if [[ -a $dmepath.m.dme ]]; then
    rm $dmepath.m.dme
fi

cp $dmepath.dme $dmepath.m.dme
if [[ $? != 0 ]]; then
    echo "Failed to make modified dme, aborting."
    exit 2
fi

for var; do
    arg=$(echo $var | sed -r 's/^.{2}//')
    if [[ $var == -D* ]]; then
        sed -i '1s!^!#define '$arg'\n!' $dmepath.m.dme
    elif [[ $var == -I* ]]; then
        sed -i 's!// BEGIN_INCLUDE!// BEGIN_INCLUDE\n#include "'$arg'"!' $dmepath.m.dme
    elif [[ $var == -M* ]]; then
        sed -i '1s/^/#define MAP_OVERRIDE\n/' $dmepath.m.dme
        sed -i 's!#include "maps\\_map_include.dm"!#include "maps\\'$arg'\\'$arg'.dm"!' $dmepath.m.dme
    fi
done

source "$( dirname "${BASH_SOURCE[0]}" )/sourcedm.sh"

if [[ $DM == "" ]]; then
    echo "Couldn't find the DreamMaker executable, aborting."
    exit 3
fi

"$DM" $dmepath.m.dme | tee build_log.txt
retval=$?

[[ -e $dmepath.m.dmb ]] && mv $dmepath.m.dmb $dmepath.dmb
[[ -e $dmepath.m.rsc ]] && mv $dmepath.m.rsc $dmepath.rsc

rm $dmepath.m.dme

exit $retval
