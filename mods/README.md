# Modpacks

## What exactly are modpacks?

Modpacks are, effectively, self-contained (modular) feature bundles. They can contain new objects, new species, new UIs, overrides for existing code, and even more. If you want a feature to be optional on a per-map or per-server basis, while ensuring it's always checked for correctness in unit tests, it should be placed in a modpack.

## Wait, but I've heard that modular code is bad!

This is a common sentiment, but it's sort of a misconception. There's nothing *inherently* wrong with modular code; after all, it's just code that'd designed for easy extension and reusability, which is always desirable in a project like SS13. However, the way other codebases tend to handle modularity by just adding new DM files in a separate folder, directly included in the DME, creates issues. Some of the common objections are:

### Load Order

With the typical way "modular" code is done, load order is difficult to manage and often results in folder names like `upstreamname`, `downstreamname`, `zzzz_servername`, etc., plus it requires editing the main DME. Modpacks have a defined, user-controlled load order, and cross-modpack compatibility is always handled after all modpacks are loaded.

### Organization and Navigation

Similarly, that file-structure makes it very difficult to organize and navigate the codebase as a whole. The original modularization standards were fairly straightforward, in that the modular folder was treated as a straight-forward layer on top of the original codebase, with files being treated as though they're present in the original codebase structure. a trend that ended up being set by other servers going for modularization was adding subdirectories of "modules", with almost every unique piece of content being given it's own individual module folder. The problem with this is that modules don't really have any defined structure or handling, and tend to just amount to subdirectories and nothing more. With every piece of content having its own module, even if they just override or overwrite base-game definitions and nothing more, this leads to the codebase being incredibly hard to navigate even if you already know roughly where what you want to modify is. This even applies to the base game, because some code is separated by type (obj, datum, etc.) and others are separated into conceptual modules.

Nebula's modpacks are similar to modules in that they're separated by concept, but modpacks are more rigorous, with scripts and tests for validation. Each modpack is tested as a unit (along with the base game) as well as in integration with other modpacks on the various included maps.

### Proc Overrides

Modular code relies heavily on overrides and even side-overrides (overrides defined after, but on the same type as, an existing proc override or definition), which can obfuscate control flow and lead to code breaking when assumptions made about the calling proc change. This is a valid concern! In a lot of cases, though, it's avoidable by making modular behaviour use explicit interfaces intended for change in modpacks, like specifying datum (often decl) handlers that receive one override each. `/decl/human_examination` is a good example of this.

### Merge Conflicts

The issue with "modularity" as done elsewhere is that it just masks conflicts; upstream files are kept intact, but they might be unincluded or the methods they define/call might be completely replaced later on. This swaps out annoying but easily-resolvable merge conflicts for the far-worse issue of silent breakage.

### Upstream Conflicts

More broadly, modular code on a downstream with an upstream that does frequent refactors and rewrites is inevitably going to break when the upstream codebase does anything. Names change, so do assumptions, and even design directions might diverge so far that reconciling them will be hard or even impossible. There's not really getting around that, but we can at least mitigate it by designing stable interfaces and documenting changes. When upstream code is written with modularity in mind, downstreams have a much easier time adding content.

### Implicit Dependencies

The idea of modular code as independent falls apart when code modules begin to require each other to function, without explicitly noting that dependency. Worse yet, sometimes there are non-modular edits to base-game code that require a particular piece of modular code to be included. Since Nebula runs unit tests on an example map with no modpacks and no map-specific code, the core game will always function without any modpacks included. Similarly, modpacks are tested one-at-a-time as well as all together, to ensure there aren't any implicit dependencies. If one modpack requires another to function, there's three methods to resolve this. First, you could have one modpack include the other, making the dependency explicit. Second, you could merge the modpacks so they aren't separate at all. Third, you could use a compatibility patch to gate the content that requires both to be loaded.

## Okay, but how do I make a modpack?

TODO: Write this section. Explain things like creating a DME, where to include the DME, etc. Also explain some common organizational conventions like `foo_overrides.dm` files and `overrides` folders to better organize overrides of base-game procs and functionality.

### How do I modpack...

- A subsystem?
  - Check the psionics modpack for an example.
- Something small?
  - Check the mundane or scaling descriptor modpacks as examples.
- NanoUI templates?
  - Check the inertial dampener or supermatter modpacks as examples. (Don't forget to set the nanoui_directory variable on the modpack decl!)

## How do I write upstream/core code with extension via modpacks in mind?

TODO: Write this section. Give examples like `/decl/atmos_grief_fix_step`, `/decl/human_examination`, the cocktails system, etc. Iterating over subtypes of a base type makes it easy for modpacks to add new code. Also maybe address some footguns like trying to make something modular before trying to make it actually work? Could also discuss the open-closed principle I guess, e.g. write code that gets *extended* rather than *modified* (so avoiding side-overrides, etc.).

# Contribution

Please contribute to this README/guide. It's currently unfinished and doesn't cover a lot of important things. Thanks.