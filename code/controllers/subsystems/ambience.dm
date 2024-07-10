SUBSYSTEM_DEF(ambience)
	name = "Ambient Lighting"
	wait = 1
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_LIGHTING
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT // Copied from icon update subsystem.
	flags = SS_NO_INIT
	var/list/queued = list()

/datum/controller/subsystem/ambience/stat_entry()
	..("P:[length(queued)]")

/datum/controller/subsystem/ambience/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queued
	while (curr.len)
		var/turf/target = curr[curr.len]
		target.ambience_queued = FALSE
		curr.len--
		if(!QDELETED(target))
			target.update_ambient_light_from_z_or_area()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/ambience/StartLoadingMap()
	suspend()

/datum/controller/subsystem/ambience/StopLoadingMap()
	wake()

/turf
	/// Whether this turf has been queued for an ambient lighting update.
	var/ambience_queued = FALSE

/turf/proc/update_ambient_light_from_z_or_area()

	// If we're not outside, we don't show ambient light.
	clear_ambient_light() // TODO: fix the delta issues resulting in burn-in so this can be run only when needed

	var/ambient_light_modifier
	// If we're indoors because of our area, OR we're outdoors and not exposed to the weather, get interior ambience.
	var/outsideness = is_outside()
	if((!outsideness && is_outside == OUTSIDE_AREA) || (outsideness && get_weather_exposure() != WEATHER_EXPOSED))
		var/area/A = get_area(src)
		if(isnull(A?.interior_ambient_light_modifier))
			return FALSE
		ambient_light_modifier = A.interior_ambient_light_modifier
	else if(is_outside == OUTSIDE_NO)
		return FALSE

	// If we're dynamically lit, we want ambient light regardless of neighbors.
	var/lit = TURF_IS_DYNAMICALLY_LIT_UNSAFE(src)
	// If we're not, we want ambient light if one of our neighbors needs to show spillover from corners.
	if(!lit)
		for(var/turf/T in RANGE_TURFS(src, 1))
			// Fuck if I know how these turfs are located in an area that is not an area.
			if(isloc(T.loc) && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
				lit = TRUE
				break

	if(lit)

		// Grab what we need to set ambient light from our level handler.
		var/datum/level_data/level_data = SSmapping.levels_by_z[z]

		// Check for daycycle ambience.
		if(level_data.daycycle_id)
			var/datum/daycycle/daycycle = SSdaycycle.get_daycycle(level_data.daycycle_id)
			var/new_power = daycycle?.current_period?.power
			if(!isnull(new_power))
				if(new_power > 0)
					set_ambient_light(daycycle.current_period.color, clamp(new_power + ambient_light_modifier, 0, 1))
				return TRUE

		// Apply general level ambience.
		if(level_data?.ambient_light_level)
			set_ambient_light(level_data.ambient_light_color, clamp(level_data.ambient_light_level + ambient_light_modifier, 0, 1))
			return TRUE

	return FALSE
