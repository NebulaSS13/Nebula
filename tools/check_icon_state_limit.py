import argparse, sys, logging
from os import path, walk
from byond.DMI import DMI

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for *.dmi files with an excess number of icon states.')
args = opt.parse_args()

if(not path.isdir(args.dir)):
    print('Not a directory')
    sys.exit(1)

failed = False
logging.getLogger().setLevel(logging.ERROR) # we don't care that byond is bad at pngs
# This section parses all *.dmi files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
    for filename in files:
        if not filename.endswith('.dmi'):
            continue
        file_path = path.join(root, filename)
        dmi = DMI(file_path)
        dmi.loadMetadata()
        number_of_icon_states = len(dmi.states)
        if number_of_icon_states > 512:
            failed = True
            print("{0} had too many icon states. {1}/512".format(file_path, number_of_icon_states))
if failed:
    sys.exit(1)
