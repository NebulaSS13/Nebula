//Initializes relatively late in subsystem init order.
SUBSYSTEM_DEF(misc_late)
	name = "Late Initialization"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE
	var/list/turbolifts_to_open = list()

/datum/controller/subsystem/misc_late/Initialize()

	// Temp: create stressor tree.
	for(var/stressor in subtypesof(/datum/stressor))
		SSmanaged_instances.get(stressor, cache_category = /datum/stressor)

	global.using_map.build_exoplanets()
	var/decl/asset_cache/asset_cache = GET_DECL(/decl/asset_cache)
	asset_cache.load()

	// This is gross but I'm not sure where else to handle it. Sorry.
	for(var/datum/turbolift/lift in turbolifts_to_open)
		if(!QDELETED(lift))
			lift.open_doors()
	turbolifts_to_open.Cut()

	. = ..()
