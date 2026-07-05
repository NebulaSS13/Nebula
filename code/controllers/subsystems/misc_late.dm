//Initializes relatively late in subsystem init order.
SUBSYSTEM_DEF(misc_late)
	name = "Late Initialization"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE

/datum/controller/subsystem/misc_late/Initialize()

	var/decl/asset_cache/asset_cache = GET_DECL(/decl/asset_cache)
	asset_cache.load()

	for(var/modpack_name in SSmodpacks.loaded_modpacks)
		var/decl/modpack/loaded_modpack = SSmodpacks.loaded_modpacks[modpack_name]
		loaded_modpack.on_misc_late_init()

	// Pre-populate the emote list.
	decls_repository.get_decls_of_type(/decl/emote)

	. = ..()
