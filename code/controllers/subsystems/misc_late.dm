//Initializes relatively late in subsystem init order.
SUBSYSTEM_DEF(misc_late)
	name = "Late Initialization"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE

/datum/controller/subsystem/misc_late/Initialize()
	global.using_map.build_exoplanets()
	var/decl/asset_cache/asset_cache = GET_DECL(/decl/asset_cache)
	asset_cache.load()
	. = ..()
