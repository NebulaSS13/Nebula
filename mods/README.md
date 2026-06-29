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

### Overriding Core Code
Sometimes a modpack needs to change how existing non-modpack code behaves, rather than just add new content. Because DM lets you extend any type in any file, a modpack can re-declare an existing type and redefine its vars or procs. This is called a *side-override*: normal overrides are created deeper in the type hierarchy on a subtype, while side-overrides exist 'to the side' of the existing override(s) for a type. (Even though it's not on a parent- or child-type, we still call `..()` the "parent call" even inside a side-override.)

This is the *opposite* of the approach described in "How do I write upstream/core code with extension via modpacks in mind?" below. That section is about writing core code so modpacks can hook into it without touching it; this section is about the cases where you have to touch it anyway. Prefer the extension approach when stock code already offers a hook (a decl subtype to add, a list to append to, a subtype to iterate over). Reach for a side-override only when there's no such entry point.

By convention, overrides go in a file named `overrides.dm` (or `<thing>_overrides.dm` for a focused group, e.g. `living_overrides.dm`) and are `#include`d from the modpack's `.dme` like any other file. Keeping them in clearly-named files makes it obvious at a glance which stock behavior a modpack changes. Cleverly-designed modpacks will define their core code hooks/overrides separate from per-type value overrides, so they can change as little as possible for each type, making changes less brittle.

#### Overriding a var
The simplest type of override just extends an existing type and changes variable values:

```dm
// mods/content/fantasy/items/material_overrides.dm
// FRANCE ISN'T REAL
/obj/item/chems/drinks/bottle/champagne
	name = "sparkling wine bottle"

/decl/material/liquid/alcohol/champagne
	name       = "sparkling wine"
	glass_name = "sparkling wine"
	glass_desc = "Sparkling white wine, a favourite at noble and merchant parties."
	lore_text  = "Sparkling white wine, a favourite at noble and merchant parties."
```

This is safe and done entirely at compile-time without adding any new code; it just changes the initial value of vars that the existing type already declares. The only conflict risk is two modpacks setting the same var on the same type to different values, in which case the last one loaded wins. Some modpacks may intend this, while others may want to write a compatibility patch (see below).

#### Overriding a proc
To change behavior, redefine the proc on the existing type. Most overrides should call `..()` so the stock implementation (and any other modpack's override of it) still runs:

```dm
// mods/content/augments/passive/armor.dm
// override to add armor augment damage mods
/obj/item/organ/external/get_brute_mod(var/damage_flags)
	. = ..()                    // run the stock proc, keep its result
	var/obj/item/organ/internal/augment/armor/armor_augment = owner?.get_organ(BP_AUGMENT_CHEST_ARMOUR, /obj/item/organ/internal/augment/armor)
	if(armor_augment)
		. *= armor_augment.brute_mult
```

You can call `..()` at the start (to modify the result afterward), at the end (to run your logic first), or conditionally (to sometimes short-circuit and sometimes defer to stock):

```dm
// mods/content/breath_holding/living_overrides.dm
// override to make a held breath take priority
/mob/living/get_breath(obj/item/organ/internal/lungs/lungs)
	if(lungs?.holding_breath && lungs.held_breath)
		return lungs.held_breath // intentionally skip the stock proc
	return ..()
```

#### Overriding a static list getter (the injector pattern)
One common pattern in core code is the *static list getter,* used to avoid creating a new list every time the getter is called. This is much more efficient, but is a little more complex to override. Take this getter, for example:

```dm
// code/game/objects/items/weapons/secrets_disk.dm
/obj/item/disk/secret_project/proc/get_secret_project_nouns()
	var/static/list/nouns = list(
		"a superluminal artillery cannon", "a fusion engine", "an atmospheric scrubber",\
		"a human cloning pod", "a microwave oven", "a wormhole generator", "a laser carbine", "an energy pistol",\
		"a wormhole", "a teleporter", "a huge mining drill", "a strange spacecraft", "a space station",\
		"a sleek-looking fighter spacecraft", "a ballistic rifle", "an energy sword", "an inanimate carbon rod"
	)
	return nouns
```

We want to extend this by adding "a supermatter engine" to the list. A naive approach might be like this:

```dm
//Example code not actually used
/obj/item/disk/secret_project/get_secret_project_nouns()
	. = ..()
	. += "a supermatter engine"
```

This works at first glance, if you call it once. However, because the getter uses a *static list,* it's saved between calls. That means it will be added every time we use the getter, which will quickly add a lot of duplicate entries to the list. Another naive fix for this would be using `|=` to avoid duplicates, but this is expensive because it checks if the item already exists in the list. Wouldn't it be nice to just add it once?

For this, we use something called an injector, which uses a static var to track whether or not we've run our override before. If we're running it for the first time, we make all our changes to the static list returned by `..()`, and after that we set our tracking variable to ensure we never modify it again:

```dm
// mods/content/supermatter/overrides/sm_strings.dm
/obj/item/disk/secret_project/get_secret_project_nouns()
	var/static/sm_injected = FALSE
	if(sm_injected)
		return ..()
	sm_injected = TRUE
	. = ..()
	. += "a supermatter engine"
	return .
```

This also works for removing items from static lists, and may be useful for run-once code in other contexts as well. Another good example is in mods/content/corporate/items/random.dm.

#### Footguns
- **Multiple side-overrides chain through `..()` in definition order.** Unlike a normal override, which lives on a new subtype deeper in the type tree, a side-override is defined directly on the existing type. If there are several side-overrides of `/mob/living/some_proc()`, they're all kept and chained: `..()` in the last-defined override calls the previous one, and so on down to the first, which then walks up the type tree to the base implementation. The order in which they run depends on the order they're defined in, so don't write a side-override that assumes it runs first, last, or in any particular position relative to another modpack's. (You can generally assume that it will run after the core definition, though.)
- **Extend, don't copy.** It may be easier to copy an existing proc definition, skip the parent call, and make a change somewhere in the middle. This is (almost) always a horrible idea, because you may not even notice something breaks when an update changes the definition you copied. The correct solution is to add it to an override that runs before or after the parent call, and if you *really* need to run it in the middle, consider adding a proc to the core code that your modpack can override (or split the existing proc into two or more).
- **Always call `..()` unless you really mean to break the chain.** Forgetting `..()` drops the base implementation *and* any earlier modpack's side-override, which can break unrelated core features and any other modpack that expected that proc to do its normal job. Only omit it when you genuinely intend to replace the behavior wholesale.
- **Don't depend on load order between modpacks.** A modpack may depend only on itself and stock code. If your override only makes sense when *another* modpack is also enabled, it's a cross-modpack interaction and belongs in `mods/~compatibility` (see below), which is loaded last and therefore modpack load-order agnostic.
- **Side-overrides are the most fragile thing to maintain across upstream changes.** When upstream code renames a proc, changes its signature, or alters what `..()` returns, your override breaks. The fewer side-overrides a modpack has, the less it breaks when upstream code is refactored. **There being no merge conflicts doesn't mean your code wasn't broken by an update!**

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