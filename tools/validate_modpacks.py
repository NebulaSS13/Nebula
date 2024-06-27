import fnmatch
import functools
import glob
import sys
import os

"""
Paths to search for modpacks in.
Works best if search paths are only one-deep, so that nested modpacks can be added separately.
"""
MODPACK_ROOTS = [
    r'mods/content/*/*.dme',
    r'mods/gamemodes/*/*.dme',
    r'mods/mobs/*/*.dme',
    r'mods/species/*/*.dme'
    # Example nested modpack configuration:
    # r'mods/some_downstream/*/*.dme'
]

"""
A list of DME paths to not run validation on.
Useful for excluding the outermost DME in a nested-modpack situation.
"""
IGNORE_MODPACKS = [
    # Example:
    # r'mods/some_downstream/some_downstream.dme/*.dme'
]

"""
A dictionary mapping of modpack roots ('mods/content/corporate')
to a list of globs matching files to forbid inclusion of.
If a file matches any of the globs, validation fails.
"""
FORBID_INCLUDE = {
    # Example:
    # r'mods/content/whatever/_whatever.dme' : [r'mods/content/whatever/README.md', r'mods/content/whatever/something/something_docs.md']
}

"""
A dictionary mapping of modpack roots ('mods/content/corporate')
to a list of globs matching files ('mods/content/corporate/away_sites/**/*.dm) to ignore when checking for inclusion.
If a file matching any of the globs is not included, validation will NOT fail.
"""
IGNORE_INCLUDE = {
    # The validator can't detect the weird way these are loaded.
    r'mods/content/corporate': [
        r'mods/content/corporate/away_sites/**/*.dm',
    ],
    r'mods/content/government': [
        r'mods/content/government/away_sites/**/*.dm'
    ]
}

def validate_modpack(dme_path):
    (modpack_path, dme_name) = os.path.split(dme_path)
    reading = False
    lines = []
    total = 0
    with open(dme_path, 'r') as dme_file:
        for line in dme_file.readlines():
            total+=1
            line = line.strip()

            if line == "// BEGIN_INCLUDE":
                reading = True
                continue
            elif line == "// END_INCLUDE":
                break
            elif not reading:
                continue
            elif not line.startswith("#include"):
                continue

            lines.append(line)

    offset = total - len(lines)
    print(f"{offset} lines were ignored in {dme_name}")
    modpack_failed = False

    for code_file in glob.glob("**/*.dm", root_dir=modpack_path, recursive=True):
        full_file = os.path.join(modpack_path, code_file)
        dm_path = code_file.replace('/', '\\')

        included = f"#include \"{dm_path}\"" in lines
        forbid_include = False

        ignored = False

        modpack_ignores = []
        if modpack_path in IGNORE_INCLUDE:
            modpack_ignores = IGNORE_INCLUDE[modpack_path]

        for ignore in modpack_ignores:
            if not fnmatch.fnmatch(full_file, ignore):
                continue

            ignored = True
            break

        if ignored:
            continue

        modpack_forbids = []
        if modpack_path in FORBID_INCLUDE:
            modpack_forbids = FORBID_INCLUDE[modpack_path]

        for forbid in modpack_forbids:
            if not fnmatch.fnmatch(full_file, forbid):
                continue

            forbid_include = True

            if included:
                print(f"{os.path.join(modpack_path,dm_path)} should not be included")
                print(f"::error file={full_file},line=1,title=DME Validator::File should not be included")
                modpack_failed = True

        if forbid_include:
            continue

        if not included:
            print(f"{os.path.join(modpack_path,dm_path)} is not included")
            print(f"::error file={full_file},line=1,title=DME Validator::File is not included")
            modpack_failed = True

    def compare_lines(a, b):
        # Remove initial include as well as the final quotation mark
        a = a[len("#include \""):-1].lower()
        b = b[len("#include \""):-1].lower()

        a_segments = a.split('\\')
        b_segments = b.split('\\')

        for (a_segment, b_segment) in zip(a_segments, b_segments):
            a_is_file = a_segment.endswith(".dm")
            b_is_file = b_segment.endswith(".dm")

            # code\something.dm will ALWAYS come before code\directory\something.dm
            if a_is_file and not b_is_file:
                return -1

            if b_is_file and not a_is_file:
                return 1

            # interface\something.dm will ALWAYS come after code\something.dm
            if a_segment != b_segment:
                return (a_segment > b_segment) - (a_segment < b_segment)

        raise ValueError(f"Two lines were exactly the same ({a} vs. {b})")

    sorted_lines = sorted(lines, key = functools.cmp_to_key(compare_lines))
    for (index, line) in enumerate(lines):
        if sorted_lines[index] != line:
            print(f"The include at line {index + offset} is out of order ({line}, expected {sorted_lines[index]})")
            print(f"::error file={dme_path},line={index+offset},title=DME Validator::The include at line {index + offset} is out of order ({line}, expected {sorted_lines[index]})")
            modpack_failed = True
    return modpack_failed

failed = False
for modpack_root in MODPACK_ROOTS:
    for modpack_dme in glob.glob(modpack_root, recursive=True):
        modpack_dme = modpack_dme.replace('\\', '/')
        if modpack_dme in IGNORE_MODPACKS:
            continue
        failed = validate_modpack(modpack_dme) or failed

if failed:
    sys.exit(1)

