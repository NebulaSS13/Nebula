// Some duplicated behavior from SSprocessing in here so atoms can 
// still process normally as well as handling overmap movement.

SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	priority = SS_PRIORITY_OVERMAP
	wait = 2
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING | SS_NO_INIT
	var/list/moving_entities = list()
	var/list/current_run = list()

// Processing boilerplate.
/datum/controller/subsystem/overmap/fire(resumed = 0)
	if(!resumed)
		src.current_run = moving_entities.Copy()
	var/list/current_run = src.current_run
	var/wait = src.wait
	var/times_fired = src.times_fired
	while(current_run.len)
		var/obj/effect/overmap/entity = current_run[current_run.len]
		current_run.len--
		if(QDELETED(entity) || entity.ProcessOvermap(wait, times_fired) == PROCESS_KILL)
			moving_entities -= entity
		if (MC_TICK_CHECK)
			return
