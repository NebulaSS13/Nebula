#!/usr/bin/env python3

import os
import sys
import re
import json

__author__ = "MistakeNot4892"
__version__ = "0.1.0"
__license__ = "MIT"

def main():

	# Make sure they gave us a map to replicate.
	if len(sys.argv) < 2:
		print("Specify a map to replicate.")
		return

	# Make sure we can access the maps folder.
	mapname = sys.argv[1]
	mapdir =  os.path.join("maps")
	if not os.path.isdir(mapdir):
		print("Cannot find directory '" + mapdir + "', make sure you are running this script from the root repository directory.")
		return

	ckey = None
	if len(sys.argv) > 2:
		ckey = sys.argv[2]
		if ckey is not None:
			ckey = ckey.lower()

	singletargetmap = None
	if len(sys.argv) > 3:
		singletargetmap = sys.argv[3]
		if singletargetmap is not None:
			singletargetmap = singletargetmap.lower()

	# Work out what maps we actually need to replicate to.
	# This should be updated as map directories change, or the script will break.
	targetmaps = []
	ignoremaps = [
		"away",
		"away_sites_testing",
		"antag_spawn",
		"example",
		"modpack_testing",
		"random_ruins",
		"~mapsystem",
		"~unit_tests"
	]
	for dir in os.scandir(mapdir):
		if os.path.isdir(dir):
			targetmap = dir.path
			targetmap = targetmap.replace(mapdir + os.sep, "")
			if (targetmap not in ignoremaps) and (targetmap != mapname) and ((singletargetmap is None) or (singletargetmap == targetmap)):
				targetmaps.append(targetmap)

	# Make sure we can actually see the save directory.
	scrapedir = os.path.join("data", "player_saves")
	if not os.path.isdir(scrapedir):
		print("Cannot find directory '" + scrapedir + "', make sure you are running this script from the root repository directory.")
		return

	# Find existing saves for the target map, then replicate them to all our target map dirs.
	# If they exist already, don't copy over, just move on.
	filename_regex = r"character_([a-zA-Z0-9_]+)_(\d+)\.json"
	print("Scanning saves in " + scrapedir + "...")
	save_slots_to_update = []
	saves_to_replicate = []
	for (root, dirs, files) in os.walk(scrapedir):
		for file in files:
			match = re.match(filename_regex, file, re.I)
			if match is None:
				continue
			if match.group(1) != mapname:
				continue
			if (ckey is not None) and (ckey != root[root.rfind("/")+1:]):
				continue
			savefile = os.path.join(root, file)
			with open(savefile, "r") as loadedsave:
				wrote = 0
				loadedlines = loadedsave.readlines()
				for targetmap in targetmaps:
					newfilename = savefile.replace(mapname, targetmap)
					if not os.path.exists(newfilename):
						with open(newfilename, "w") as writesave:
							for line in loadedlines:
								writesave.write(line)
							wrote = wrote+1
				if wrote > 0:
					print("Wrote " + str(wrote) + " copies of " + file + ".")

	# Collect slot names for each user to update their preferences.json
	for (root, dirs, files) in os.walk(scrapedir):
		has_prefs = False
		has_saves = []
		for file in files:
			if file == "preferences.json":
				has_prefs = True
				continue
			match = re.match(filename_regex, file, re.I)
			if match is None:
				continue
			has_saves.append(file)

		if has_prefs and len(has_saves):
			new_slot_names = {}
			for savefile in has_saves:
				with open(os.path.join(root, savefile), "r") as loaded_save:
					loaded_save_json = json.load(loaded_save)
					new_slot_names[savefile.replace(".json", "")] = loaded_save_json["real_name"]
			if len(new_slot_names):
				loaded_pref_json = ""
				with open(os.path.join(root, "preferences.json"), "r") as pref_file:
					loaded_json = pref_file.read()
					loaded_pref_json = json.loads(loaded_json)
					loaded_pref_json["slot_names"] = new_slot_names
				with open(os.path.join(root, "preferences.json"), "w") as pref_file:
					pref_file.write(json.dumps(loaded_pref_json))

	# Fin.
	print("Done.")

if __name__ == "__main__":
	main()
