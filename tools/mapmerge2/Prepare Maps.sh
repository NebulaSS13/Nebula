#!/bin/sh

for dir in ../../maps/*/*.dmm
do
  cp $dir $dir.backup
done

clear
echo "All dmm files in maps directories have been backed up"
echo "Now you can make your changes..."
echo "---"
echo "Remember to run mapmerge.bat just before you commit your changes!"
echo "---"
