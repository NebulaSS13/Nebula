SUBSYSTEM_DEF(evac)
	name = "Evacuation"
	priority = SS_PRIORITY_EVAC
	//Initializes at default time
	flags = SS_NO_TICK_CHECK|SS_BACKGROUND
	wait = 2 SECONDS
	var/datum/evacuation_controller/evacuation_controller


/datum/controller/subsystem/evac/Initialize()
	. = ..()
	if(!evacuation_controller)
		evacuation_controller = new global.using_map.evac_controller_type ()
		evacuation_controller.set_up()

/datum/controller/subsystem/evac/fire()
	evacuation_controller.process()