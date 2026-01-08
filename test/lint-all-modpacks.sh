#!/bin/bash

set -o pipefail

dmepath=""

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

sed -i '1s/^/#define MAP_OVERRIDE\n/' $dmepath.m.dme
sed -i 's!#include "maps\\_map_include.dm"!#include "maps\\modpack_testing\\modpack_testing.dm"!' $dmepath.m.dme
failed=0
# Run the linter, doing a full linting rather than just parsing
~/dreamchecker -e "$dmepath.m.dme" 2>&1 | tee -a "${GITHUB_WORKSPACE}/output-annotations.txt"
# Check the return value
if [[ $? -ne 0 ]]; then
	failed=1
fi
rm $dmepath.m.dme
if [[ $failed -eq 1 ]]; then
    echo "Modpack testing map failed to pass validation."
    exit 1
fi