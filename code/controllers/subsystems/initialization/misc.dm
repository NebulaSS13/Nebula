SUBSYSTEM_DEF(misc)
	name = "Early Initialization"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE

/datum/controller/subsystem/misc/Initialize()
	if(config.generate_map)
		global.using_map.perform_map_generation()
	global.using_map.build_exterior_atmosphere()

	setupgenetics()

	transfer_controller = new
	. = ..()