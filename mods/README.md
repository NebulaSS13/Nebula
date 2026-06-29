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
This is the counterpart of "Overriding Core Code" above. There, a modpack reaches into core code and changes it from the side; here, you're the one writing the core code, and your goal is to leave an *entry point* that modpacks can hook into without ever editing your code. The guiding idea is the open/closed principle: code should be open for extension but closed for modification. Every time a modpack can add a feature by writing a new file instead of side-overriding one of yours, that's one fewer thing that silently breaks when you refactor later.

The single most useful tool for this is **iterating over decl subtypes.** Define an abstract decl as a hook point, write your core logic to enumerate every subtype of it and call into them, and modpacks extend the system simply by defining a new subtype. Nothing in core needs to know the modpack exists.

### Pattern: action decls
Take the "fix atmospherics grief" admin tool. Core code defines an abstract decl with a small interface, then enumerates every subtype, sorts them, and calls each:

```dm
// code/modules/admin/verbs/grief_fixers.dm
/decl/atmos_grief_fix_step
	abstract_type = /decl/atmos_grief_fix_step
	var/name

/decl/atmos_grief_fix_step/proc/act()
	return

// ...elsewhere, the verb that runs them all:
var/list/steps = decls_repository.get_decls_of_subtype_unassociated(/decl/atmos_grief_fix_step)
steps = sortTim(steps.Copy(), /proc/cmp_decl_sort_value_asc)
for(var/decl/atmos_grief_fix_step/fix_step as anything in steps)
	to_chat(usr, "[fix_step.name].")
	fix_step.act()
```

A modpack can then add a step without touching any of the above. It just defines a new subtype and the core loop runs it in the specified order:

```dm
// mods/content/supermatter/datums/sm_grief_fix.dm
/decl/atmos_grief_fix_step/supermatter
	name = "Supermatter depowered"
	sort_order = 0

/decl/atmos_grief_fix_step/supermatter/act()
	// Depower the supermatter, as it would quickly blow up once we remove all gases from the pipes.
	for(var/obj/structure/supermatter/S in SSsupermatter.processing)
		S.power = 0
```

Note the two things that make this clean: `abstract_type` marks the base as not-runnable so the enumeration only picks up real steps, and a `sort_order` var (read by the `cmp_decl_sort_value_asc` comparator) lets each subtype declare where it belongs in the sequence rather than relying on definition or load order. When you design a hook like this, give modpacks an explicit ordering knob instead of leaving order undefined.

### Pattern: output builder decls
Enumerable decls don't have to *do* something; they can be useful just for a calculation or return value used in base-game code. Human examination text works this way. Base human examination code defines a stub decl whose whole purpose is to be subtyped by modpacks:

```dm
// code/modules/mob/living/human/human_examine_decl.dm
/decl/human_examination //This is essentially a stub-method for modpacks to be able to add onto the human examination stuff
	var/priority = 0

/decl/human_examination/proc/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns)
	return
```

Core's examine code enumerates these decls (sorted by `priority`) and appends whatever each returns. A modpack adds a line to the examine output by defining a subtype of `/decl/human_examination` and implementing `do_examine()`; see `mods/content/matchmaking/matchmaker.dm` for a working example.

### Pattern: condition/recipe decls
Similarly to output builder decls (see prior section), the cocktails system (`code/modules/reagents/cocktails.dm`), chemical reaction system (`code\modules\reagents\reactions\_reaction.dm`), and stack recipe system (`code\modules\crafting\stack_recipes\_recipe.dm`) follow a similar idea: a base type that gets enumerated, so modpacks add new recipes by adding subtypes rather than editing a central list. By combining this with other principles, modpacks can extend, remove, or modify existing recipes, cocktails, reactions, etc. without needing to edit them directly.

### Pattern: events (`/decl/observ`)
The decl patterns above allow core and modpack code to request extensible subtypes representing information, behavior, or conditions. Conversely, events allow modular code to request an update when something particular happens, and they're easily the most versatile tool for writing code that doesn't require side-overrides. When something notable happens, core code raises an event, and anything that cares can register to be notified. The code raising the event has no idea who's listening, and never needs a call added for each new listener. This is exactly what makes it good for modular code: a modpack can react to a core event (or even another modpack's event) without the event-issuing code containing a single reference to the consumer of that event.

An event is a `/decl/observ` subtype. Defining one is just a declaration plus a doc comment describing the arguments listeners will receive:

```dm
// code/datums/observation/death.dm
//	Raised when: A mob dies.
//	Arguments the called proc should expect:
//		/mob/dying_mob: the mob that died.
/decl/observ/death
	name = "Death"
	expected_type = /mob
```

Events are typically raised with the `RAISE_EVENT` macro, passing the source as the first argument followed by any event-specific arguments.

```dm
// code/datums/observation/death.dm
/mob/living/add_to_dead_mob_list()
	. = ..()
	if(.)
		RAISE_EVENT(/decl/observ/death, src)
```

A modpack (or any object) hooks in by registering a callback through `events_repository`. The arguments are `(event_type, event_source, listener, proc_to_call)`; the listener's proc receives the event source plus whatever extra args the event documents. Crucially, you must **unregister** when you no longer care (and always before the listener is destroyed), or the listener will be forced to clean them up manually on deletion, which can be slow. This augment registers on the item it's holding and tears the registration down when that item goes away (through another event):

```dm
// mods/content/augments/simple.dm
/obj/item/organ/internal/augment/active/simple/Initialize()
	. = ..()
	// ...
	events_repository.register(/decl/observ/moved,      holding, src, PROC_REF(check_holding))
	events_repository.register(/decl/observ/destroyed,  holding, src, PROC_REF(check_holding))

/obj/item/organ/internal/augment/active/simple/proc/check_holding()
	if(QDELETED(holding))
		events_repository.unregister(/decl/observ/moved,     holding, src)
		events_repository.unregister(/decl/observ/destroyed, holding, src)
		holding = null
```

Pass `event_source` to register for events from one specific object; use `register_global(event_type, listener, proc_call)` to hear about that event from *every* source. Some high-traffic events forbid this for performance with the `OBSERVATION_NO_GLOBAL_REGISTRATIONS` flag, so check the event's definition; if writing something that may need that level of performance, `raise_event_non_global` can be used instead of `RAISE_EVENT`.

When you're writing core code, raising an event is the right move whenever you can imagine *someone, someday* wanting to react to something (death, an item moving, a mob examining something) without you knowing who they are or why they want it. It costs one `RAISE_EVENT` line (and the overhead of dispatching events to listeners) and buys almost-unlimited extensibility in modpacks.

The problem is it's easy to get overeager: every event has a small registration/dispatch cost, so raise them when needed rather than sprinkling them everywhere on the off chance. You can always make an upstream PR to add a new event when it's needed.

As an aside, those familiar with TGstation's "DCS" system (datum, component, signal) will recognize this as very similar to TG's signals. They do functionally the same thing.

### Pattern: extensions (`/datum/extension`)
Events let modpacks react to *moments*; extensions let them attach *state and behavior* to an object without subtyping it or piling vars onto its definition. An extension is a separate datum (`/datum/extension`) that hangs off a "holder" datum, keeping a self-contained feature's data and procs encapsulated in its own type instead of smeared across the holder's variable space. This is composition over inheritance: rather than making a new `/obj/item/chems/pill` subtype for "a pill that hides what it contains," you attach an `obfuscated_medication` extension to any pill.

That separation of concerns is the whole point. The holder doesn't grow a var or a proc for the feature; the feature lives entirely in the extension, can be attached to several unrelated holder types (anything matching its `expected_type`), and can be added or removed at runtime. For a modpack this means adding a self-contained capability to a core object while not touching the core object's *definition* at all. This can even be useful in core code for functionality shared across types whose common ancestor is unacceptably early in the type hierarchy, like `/datum/extension/loaded_cell` (`code\datums\extensions\cell\cell.dm`) or `/datum/extension/padding` (`code\datums\extensions\padding\padding.dm`).

An extension subtype sets `base_type` (attaching a second extension derived from the same `base_type` replaces the first) and `expected_type` (the holders it's allowed on, enforced at construction):

```dm
// mods/content/bigpharma/extension.dm
/datum/extension/obfuscated_medication
	base_type     = /datum/extension/obfuscated_medication
	expected_type = /obj/item
	flags         = EXTENSION_FLAG_IMMEDIATE
	var/original_reagent

/datum/extension/obfuscated_medication/pill
	expected_type = /obj/item/chems/pill

/datum/extension/obfuscated_medication/pill/update_appearance()
	var/obj/item/pill = holder    // every extension knows its holder
	pill.icon_state = get_medication_icon_state_from_reagent_name(original_reagent, "pill", 1, 5)
```

You attach an extension to a holder via `set_extension(holder, extension_type, ...)`; any extra arguments are forwarded to the extension's `New()`/`post_construction()`. Then you can retrieve it with `get_extension(holder, base_type)`. By default extensions are lazy-loaded (only instantiated on first `get_extension`); set `EXTENSION_FLAG_IMMEDIATE` if it must exist the moment it's attached. There's also `has_extension()` (a cheap presence check that won't trigger lazy instantiation), `remove_extension()`, and `get_or_create_extension()`:

```dm
// mods/content/augments/active/cyberbrain.dm
/obj/item/organ/internal/augment/active/cyberbrain/Initialize()
	. = ..()
	// ...
	set_extension(src, /datum/extension/interactive/os/device/implant)
	set_extension(src, /datum/extension/assembly/modular_computer/cyberbrain)
	// ...

/obj/item/organ/internal/augment/active/cyberbrain/proc/install_default_hardware()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	for(var/component_type in default_hardware)
		assembly.try_install_component(null, new component_type(src))
```

Note that the cyberbrain above attaches *two* unrelated extensions (a modular-computer assembly extension and the OS extension) to one organ. Each is a distinct concern with its own state, neither knows about the other, and neither required a new organ subtype.

When you're writing core code, prefer an extension over adding vars/procs to a base type whenever the feature is **optional, self-contained, or only relevant to some instances.** This keeps the base type lean and gives modpacks a clean attachment point. Create a subtype instead when the behavior is intrinsic to what the object *is* rather than an add-on. As with all of these patterns, don't build an extension for something only one type will ever use and that isn't a separable concern; overengineering is the enemy of getting things done.

As with observation events, those familiar with DCS will note that these are similar to components, with the caveat that explicitly checking for extensions and calling methods on them is perfectly acceptable. You can still avoid it through the use of events, and doing so will often lead to cleaner, more extensible code (after all, if you need to add a hook, chances are something else will too), but it is by no means mandatory or even preferred by all developers.

### Other hooks worth leaving
- **Append to lists, don't replace them.** If core code builds a list that modpacks might want to add to, expose it (or build it from decl subtypes) so a modpack can contribute an entry. The static-list-getter injector pattern in "Overriding Core Code" above exists precisely *because* a getter didn't leave an easier entry point. Don't make modpacks resort to it if you can offer a cleaner hook.
- **Split a proc to create a hook.** If a modpack would otherwise need to side-override the middle of a long proc (the "Extend, don't copy" footgun), the right fix on the core side is to factor that middle out into its own overridable proc, so modpacks can override the small piece and call `..()`.
- **Add vars to a type for modpacks to fill in.** A core type can carry a var that core logic respects but only modpacks ever set, letting modpacks opt into behavior declaratively.

### Footguns
- **Don't focus too hard on abstraction before getting something working.** It's tempting to design an elaborate system ahead of time to make implementation easier, but a structure for extension is only useful once you understand what that structure needs to accomplish. Implement a working feature first, *then* focus on the points modpacks might actually want to modify. Time spent abstracting and modularizing a system that's fundamentally broken is time wasted.
- **A stable interface is a promise.** Once modpacks (and downstreams) hook into your decl or proc, renaming it or changing its signature breaks them silently. Treat hook points as a small, deliberate API: keep them narrow, name them clearly, and **document them,** because changing them is more troublesome than changing ordinary internal code.
- **Be aware of subtype ordering.** If the order your subtypes run in matters, give them an explicit ordering var (like `sort_order`/`priority` above). Relying on enumeration or load order makes behavior depend on which modpacks happen to be enabled, which is exactly the kind of fragility this whole approach is meant to avoid.

# Contribution
Please contribute to this README/guide. It's currently unfinished and doesn't cover a lot of important things. Thanks.