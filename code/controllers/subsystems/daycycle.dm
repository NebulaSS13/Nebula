///Subsystem for updating day/night ambient lighting for sets of z-levels that share a common day/night state.
SUBSYSTEM_DEF(daycycle)
	name       = "Day Cycle"
	priority   = SS_PRIORITY_DAYCYCLE
	wait       = 10 SECONDS
	flags      = SS_BACKGROUND | SS_POST_FIRE_TIMING | SS_NO_INIT
	runlevels  = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = SS_INIT_TICKER
	var/list/daycycles = list()
	var/list/current_run

/datum/controller/subsystem/daycycle/proc/remove_level(level_z, daycycle_id)
	var/datum/daycycle/daycycle = get_daycycle(daycycle_id)
	if(!daycycle)
		return
	if(islist(level_z))
		for(var/linked_level in level_z)
			daycycle.remove_level(linked_level)
	else
		daycycle.remove_level(level_z)

/datum/controller/subsystem/daycycle/proc/register_level(level_z, daycycle_id, daycycle_type = /datum/daycycle/exoplanet)
	var/datum/daycycle/daycycle = get_daycycle(daycycle_id, daycycle_type, create_if_missing = TRUE)
	if(islist(level_z))
		for(var/linked_level in level_z)
			daycycle.add_level(linked_level)
	else
		daycycle.add_level(level_z)

/datum/controller/subsystem/daycycle/proc/get_daycycle(daycycle_id, daycycle_type = /datum/daycycle/exoplanet, create_if_missing)
	if(get_config_value(/decl/config/toggle/disable_daycycle))
		return //If disabled, we don't add anything
	var/datum/daycycle/daycycle = daycycles[daycycle_id]
	if(!daycycle && create_if_missing)
		daycycle = new daycycle_type(daycycle_id)
		daycycles[daycycle_id] = daycycle
	return daycycle

/datum/controller/subsystem/daycycle/fire(resumed = 0)
	if(get_config_value(/decl/config/toggle/disable_daycycle))
		disable()
		LAZYCLEARLIST(current_run)
		return
	if(!resumed)
		current_run = daycycles?.Copy()
	while(length(current_run))
		var/cycle_id = current_run[current_run.len]
		var/datum/daycycle/cycle = current_run[cycle_id]
		current_run.len--
		if(istype(cycle))
			cycle.tick()
			if (MC_TICK_CHECK)
				return
