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

sed -i '1s/^/#define MAP_OVERRIDE\n/' $dmepath.m.dme
sed -i 's!#include "maps\\_map_include.dm"!#include "maps\\example\\example.dm"!' $dmepath.m.dme

# find feature DMEs to include. they're located in mods/**/**/*.dme. for example: mods/content/fantasy/_fantasy.dme
# it is guaranteed that each feature folder has only one DME file, so wildcard matching will work
dme_features=$(find mods -mindepth 3 -type f -name '*.dme')
# some features may be bare DM files, located at mods/**/*.dm. for example: mods/content/mundane.dm
# it is guaranteed that all bare DM files directly in mods/content, mods/gamemodes, and similar folders are able to be included as features
dm_features=$(find mods -mindepth 2 -maxdepth 2 -name '*.dm' ! -path 'mods/~*/*' ! -path 'mods/*/~.dm' )
# do some sort of for loop to insert a feature at the end of the DME prior to #include "mods\~compatibility\~compatibility.dm"
# run ~/dreamchecker -e $dmepath.m.dme 2>&1 | tee -a ${GITHUB_WORKSPACE}/output-annotations.txt
# then remove the inserted feature after so the next step in the loop can test a new feature
failed=0
for feature in $dme_features $dm_features; do
    echo "Testing feature: $feature"
    # Include the feature
    sed -i "/#include \"mods\\\\_modpack.dm\"/a#include \"$feature\"" "$dmepath.m.dme"
    # Run the linter, only doing parsing to catch undefined vars and keywords
    ~/dreamchecker -e "$dmepath.m.dme" --parse-only 2>&1 | tee -a "${GITHUB_WORKSPACE}/output-annotations.txt"
    # Check the return value
    if [[ $? -ne 0 ]]; then
        failed=1
    fi
    # Remove the feature include
    sed -i "\\:#include \"$feature\":d" "$dmepath.m.dme"
done
rm $dmepath.m.dme
if [[ $failed -eq 1 ]]; then
    echo "One or more modpacks failed to pass solo validation."
    exit 1
fi