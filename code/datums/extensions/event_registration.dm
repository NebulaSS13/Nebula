// For registering for events to be called when certain conditions are met.

/datum/extension/event_registration
	base_type = /datum/extension/event_registration
	expected_type = /datum
	flags = EXTENSION_FLAG_IMMEDIATE
	var/decl/observ/event
	var/datum/target
	var/callproc

/datum/extension/event_registration/New(datum/holder, decl/observ/event, datum/target, callproc)
	..()
	event.register(target, src, PROC_REF(trigger))
	events_repository.register(/decl/observ/destroyed, target, src, PROC_REF(qdel_self))
	src.event = event
	src.target = target
	src.callproc = callproc

/datum/extension/event_registration/Destroy()
	events_repository.unregister(/decl/observ/destroyed, target, src)
	event.unregister(target, src)
	. = ..()

/datum/extension/event_registration/proc/trigger()
	call(holder, callproc)(arglist(args))

// Only forwards the event if the given area isn't in a moving shuttle.

/datum/extension/event_registration/shuttle_stationary
	base_type = /datum/extension/event_registration/shuttle_stationary
	var/list/shuttles_registered
	var/shuttle_moving = FALSE
	var/given_area

/datum/extension/event_registration/shuttle_stationary/New(datum/holder, decl/observ/event, datum/target, callproc, area/given_area)
	..()
	src.given_area = given_area
	register_shuttles()
	events_repository.register_global(/decl/observ/shuttle_added, src, PROC_REF(shuttle_added))

/datum/extension/event_registration/shuttle_stationary/proc/register_shuttles()
	if(given_area in SSshuttle.shuttle_areas)
		for(var/shuttle_name in SSshuttle.shuttles)
			var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle_name]
			if(given_area in shuttle_datum.shuttle_area)
				events_repository.register(/decl/observ/shuttle_moved, shuttle_datum, src, PROC_REF(shuttle_moved))
				events_repository.register(/decl/observ/shuttle_pre_move, shuttle_datum, src, PROC_REF(shuttle_pre_move))
				LAZYADD(shuttles_registered, shuttle_datum)

/datum/extension/event_registration/shuttle_stationary/proc/unregister_shuttles()
	for(var/datum/shuttle_datum in shuttles_registered)
		events_repository.unregister(/decl/observ/shuttle_moved, shuttle_datum, src)
		events_repository.unregister(/decl/observ/shuttle_pre_move, shuttle_datum, src)
	shuttles_registered = null

/datum/extension/event_registration/shuttle_stationary/proc/shuttle_added(datum/shuttle/shuttle)
	if(given_area in shuttle.shuttle_area)
		events_repository.register(/decl/observ/shuttle_moved, shuttle, src, PROC_REF(shuttle_moved))
		events_repository.register(/decl/observ/shuttle_pre_move, shuttle, src, PROC_REF(shuttle_pre_move))
		LAZYADD(shuttles_registered, shuttle)

/datum/extension/event_registration/shuttle_stationary/Destroy()
	unregister_shuttles()
	events_repository.unregister_global(/decl/observ/shuttle_added, src)
	. = ..()

/datum/extension/event_registration/shuttle_stationary/proc/shuttle_moved()
	shuttle_moving = FALSE
	unregister_shuttles()
	register_shuttles()

/datum/extension/event_registration/shuttle_stationary/proc/shuttle_pre_move()
	shuttle_moving = TRUE

/datum/extension/event_registration/shuttle_stationary/trigger()
	if(!shuttle_moving)
		..()