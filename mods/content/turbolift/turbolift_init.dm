/decl/modpack/turbolift
	/// A list of turbolift holders to initialize.
	var/list/obj/abstract/turbolift_spawner/turbolifts_to_initialize = list()
	/// A list of turbolift datums whose currently-selected floor will open on misc-late init.
	var/list/datum/turbolift/turbolifts_to_open = list()

/decl/modpack/turbolift/on_mapping_pre_finalize()
	// Generate turbolifts last, since away sites may have elevators to generate too.
	for(var/obj/abstract/turbolift_spawner/turbolift as anything in turbolifts_to_initialize)
		turbolift.build_turbolift()

/decl/modpack/turbolift/on_misc_late_init()
	for(var/datum/turbolift/lift in turbolifts_to_open)
		if(!QDELETED(lift))
			lift.open_doors()
	turbolifts_to_open.Cut()
