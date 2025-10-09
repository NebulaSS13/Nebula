# Modpacks

## What exactly are modpacks?
Modpacks are, effectively, self-contained (modular) feature bundles. They can contain new objects, new species, new UIs, overrides for existing code, and even more. If you want a feature to be optional on a per-map or per-server basis, while ensuring it's always checked for correctness in unit tests, it should be placed in a modpack.

## Are modpacks the same as 'module' folders in other codebases?
No. Those were more or less just subdirectories that organized features into conceptual 'modules', but lacked any sort of defined structure or handling, and generally couldn't be selectively enabled or disabled. Nebula's modpacks are more rigorous, with scripts and tests for validation. Each modpack is tested as a unit (along with the base game) as well as in integration with other modpacks on the various included maps.

## Making a new modpack
All of Nebula's modpacks are kept inside of the `/mods` subdirectory.

Code inside of a modpack must depend on only itself and stock Nebula code, and not from other modpacks. Cross-modpack code goes elsewhere and is discussed further below.

Do NOT tick files inside of your modpack, as that'll add it to the base Nebula .dme file. Instead, you must add them to your modpack's .dme file.

### Modpack .dme
Each modpack contains its own .dme file, as the modpack is more or less a mini codebase contained within the larger stock Nebula codebase. The .dme needs to be at the base of your modpack directory.
By convention, the .dme should share the same name as the modpack itself, with a leading underscore in front.
The first line of the .dme should be an `#ifndef`, and then a define for your modpack, e.g. `#ifndef MODPACK_YOUR_MODPACK_NAME_HERE`. This needs to be unique across the codebase.
The second line should be a `#define`, and then the same thing as before, e.g. `#define MODPACK_YOUR_MODPACK_NAME_HERE`.
Below that, you should `#include` all of the paths of the files which are inside. The paths are relative to where the .dme is.
At the bottom, after all of the `#define`s, you must add `#endif`. Make sure to add `// BEGIN_INCLUDE` and `// END_INCLUDE` after the `#define` and before the `#endif`.

### Modpack Decl
Every modpack has a `/decl/modpack` subtype.

By convention, the decl is defined at the base of the modpack directory, with the .dm file sharing the same name as the modpack, with a leading underscore, the same as the .dme file.

The decl also lets players to see which modpacks a server is currently running, and holds some miscellaneous information to use for things such as dreams and the round-end credits screen.

You can have code run during server initialization, or the round starting, by overriding `pre_initialize()`, `initialize()`, `post_initialize()`, and `on_roundstart()` on your modpack's decl.

If your modpack has NanoUI templates, you must set the `nanoui_directory` variable to point to the path of the folder where the templates are, or NanoUI won't be able to find them in-game.

### Load Order
Modpacks have a defined, user-controlled load order, and cross-modpack compatibility is always handled after all modpacks are loaded.

### Enabling Your Modpack
Modpacks are enabled on a per-map basis. To activate a modpack, you `#include` the modpack's .dme in a map's .dme file.

### Overriding Stock Code
TODO: Actually write this section. It's distinct from the "How do I write upstream/core code with extension via modpacks in mind?" part because it's the *opposite,* this section is about overriding core code while the other section is about writing core code to be extended. Maybe do a basic explanation of side-overrides and associated footguns here.

### Cross-modpack interactions
Sometimes, a modpack that's enabled might need to do something in response to another modpack also being enabled. Compatibility patches allow for this to happen without the modpacks in question requiring a hard dependency on each other.

An example of such an interaction is that the Supermatter content modpack can give the SM monitoring program to engineering jobs that exist inside the Standard Jobs modpack. Another example is allowing content in the Psionics content modpack to interact with content in the Cult gamemode modpack.

Cross-modpack code is kept inside of `/mods/~compatibility`. There is another README inside which has more information.

Some modpacks extend other modpacks and make no sense to include on their own, in which case it's generally okay to make the extension modpack have a hard dependency on the original one by `#include`ing the original modpack's DME in the new one.

### How do I modpack...
- A subsystem?
  - Check the psionics modpack for an example.
- Something small?
  - Check the mundane or scaling descriptor modpacks as examples.
- NanoUI templates?
  - Check the inertial dampener or supermatter modpacks as examples. (Don't forget to set the nanoui_directory variable on the modpack decl!)

## Using modpacks as a downstream server
Modular code on a downstream with an upstream that does frequent refactors and rewrites is inevitably going to break when the upstream codebase does anything. Names change, so do assumptions, and even design directions might diverge so far that reconciling them will be hard or even impossible. There's not really getting around that, but we can at least mitigate it by designing stable interfaces and documenting changes. When upstream code is written with modularity in mind, downstreams have a much easier time adding content.

## How do I write upstream/core code with extension via modpacks in mind?
TODO: Actually write this section. Give examples like `/decl/atmos_grief_fix_step`, `/decl/human_examination`, the cocktails system, etc. Iterating over subtypes of a base type makes it easy for modpacks to add new code. Also maybe address some footguns like trying to make something modular before trying to make it actually work? Could also discuss the open-closed principle I guess, e.g. write code that gets *extended* rather than *modified* (so avoiding side-overrides where possible, etc.).

# Contribution
Please contribute to this README/guide. It's currently unfinished and doesn't cover a lot of important things. Thanks.