// This must be included before maps and any modpacks that use it.
// That includes before _map_include.dm.

/// A spawner that can have its path overridden by a modpack, so that maps can have optional modpack compatibility.
/obj/abstract/modpack_compat
	abstract_type = /obj/abstract/modpack_compat
	name = "optional modpack object"
	desc = "This item type is used to spawn a movable at roundstart, whether a modpack is included or not."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/atom/movable/spawn_object

/obj/abstract/modpack_compat/Initialize()
	..()
	if(ispath(spawn_object))
		new spawn_object
	return INITIALIZE_HINT_QDEL

#define OPTIONAL_SPAWNER(TYPE, VALUE) \
/obj/abstract/modpack_compat/##TYPE { \
	spawn_object = VALUE; \
}

/// This spawner is used to optionally spawn the aliumizer if the random aliens modpack is included.
OPTIONAL_SPAWNER(aliumizer, null)
/// This spawner is used to optionally spawn the hand teleporter if the integrated electronics modpack is included.
OPTIONAL_SPAWNER(hand_tele, null) // todo: add a non-prefab hand tele variant for use without the modpack?