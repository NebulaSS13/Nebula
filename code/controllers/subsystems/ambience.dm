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
		curr.len--
		if(!QDELETED(target))
			target.update_ambient_light_from_z_or_area()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/turf/proc/update_ambient_light_from_z_or_area()

	// If we're not outside, we don't show ambient light.
	clear_ambient_light() // TODO: fix the delta issues resulting in burn-in so this can be run only when needed

	var/override_light_power
	var/override_light_color
	// If we're indoors because of our area, OR we're outdoors and not exposed to the weather, get interior ambience.
	var/outsideness = is_outside()
	if((!outsideness && is_outside == OUTSIDE_AREA) || (outsideness && get_weather_exposure() != WEATHER_EXPOSED))
		var/area/A = get_area(src)
		if(!A || !A.interior_ambient_light_level)
			return FALSE
		override_light_power = A.interior_ambient_light_level
		override_light_color = A.interior_ambient_light_color || COLOR_WHITE

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

		// If we're using area lighting, we're indoors, so shouldn't use level data ambience.
		if(override_light_power)
			set_ambient_light(override_light_color || COLOR_WHITE, override_light_power)
			return TRUE

		// Grab what we need to set ambient light from our level handler.
		var/datum/level_data/level_data = SSmapping.levels_by_z[z]
		if(level_data?.ambient_light_level)
			set_ambient_light(level_data.ambient_light_color, level_data.ambient_light_level)
			return TRUE

	return FALSE
