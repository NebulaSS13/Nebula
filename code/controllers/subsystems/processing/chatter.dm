PROCESSING_SUBSYSTEM_DEF(radiochatter)
	name = "Radio Chatter"
	priority = SS_PRIORITY_DEFAULT
	init_order = SS_INIT_MISC_LATE
	wait = 1 SECOND

/datum/controller/subsystem/processing/radiochatter/Initialize()
	. = ..()
	for(var/ctype in global.using_map.get_radio_chatter_types())
		GET_DECL(ctype) // Will start processing on us in New(); linter does not like START_PROCESSING(src, foo) for some reason
