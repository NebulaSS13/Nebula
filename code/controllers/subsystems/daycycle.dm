

SUBSYSTEM_DEF(daycyle)
	name       = "Day Cycle"
	priority   = SS_PRIORITY_DAYCYCLE
	wait       = 1 MINUTE
	flags      = SS_BACKGROUND | SS_POST_FIRE_TIMING | SS_NO_INIT
	runlevels  = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = SS_INIT_TICKER
	var/list/registered_levels
	var/list/current_run

///Adds a set of levels that should all be updated at the same time and share the same day state
/datum/controller/subsystem/daycyle/proc/add_linked_levels(var/list/level_ids, var/start_at_night = FALSE, var/update_interval = 5 MINUTES)
	if(global.config.disable_daycycle)
		return //If disabled, we don't add anything
	var/topmost_level_id = level_ids[1]
	if(LAZYISIN(registered_levels, topmost_level_id))
		CRASH("Tried to add a set of level ids that was already registered! ('[topmost_level_id]')")
	LAZYSET(registered_levels, topmost_level_id, new /datum/ssdaycycle_registered(level_ids, start_at_night, update_interval))

/datum/controller/subsystem/daycyle/proc/remove_linked_levels(var/topmost_level_id)
	if(!LAZYISIN(registered_levels, topmost_level_id))
		return
	LAZYREMOVE(registered_levels, topmost_level_id)

/datum/controller/subsystem/daycyle/fire(resumed = 0)
	if(global.config.disable_daycycle)
		disable()
		LAZYCLEARLIST(current_run)
		return //If disabled, we shouldn't fire
	if(!resumed)
		current_run = registered_levels?.Copy()
	while(length(current_run))
		var/datum/ssdaycycle_registered/levels = current_run[current_run.len]
		levels = current_run[levels]
		current_run.len--
		//Make sure it's time to run it, otherwise skip
		if(REALTIMEOFDAY >= (levels.time_last_column_update + levels.update_interval))
			levels.update_all_daycolumns()
		if (MC_TICK_CHECK)
			return

///////////////////////////////////////////////////////////////////////////
// Day Cycle Entry
///////////////////////////////////////////////////////////////////////////

///Data on a set of z-levels getting daylight updates
/datum/ssdaycycle_registered
	var/list/level_ids
	var/is_applying_night = FALSE
	var/update_interval   = 5 MINUTES
	var/daycolumn_x = 1
	var/time_last_column_update

	var/list/x_min
	var/list/x_max
	var/list/y_min
	var/list/y_max
	var/list/level_z

/datum/ssdaycycle_registered/New(var/list/_level_ids, var/_start_at_night = is_applying_night, var/_update_interval = update_interval)
	. = ..()
	level_ids         = _level_ids
	is_applying_night = _start_at_night
	update_interval   = _update_interval
	for(var/ID in _level_ids)
		add_level(ID)
	daycolumn_x = world.maxx

/datum/ssdaycycle_registered/proc/add_level(var/level_id)
	var/datum/level_data/LD = SSmapping.levels_by_id[level_id]
	LAZYADD(x_min, (LD.level_inner_x || 1))
	LAZYADD(y_min, (LD.level_inner_y || 1))
	LAZYADD(x_max, (LD.level_inner_x? (LD.level_inner_x + LD.level_inner_with)   : world.maxx))
	LAZYADD(y_max, (LD.level_inner_y? (LD.level_inner_y + LD.level_inner_height) : world.maxy))
	LAZYADD(level_z, LD.level_z)

/datum/ssdaycycle_registered/proc/remove_level(var/level_id)
	if(!level_ids)
		return
	var/level_index
	for(var/i = 1 to length(level_ids))
		if(level_ids[i] == level_id)
			level_index = i
			break
	if(!level_index)
		return

	//Remove the thing from all list and make sure they all match by index
	level_ids.Cut(level_index, level_index)
	x_min.Cut(level_index, level_index)
	x_max.Cut(level_index, level_index)
	y_min.Cut(level_index, level_index)
	y_max.Cut(level_index, level_index)
	level_z.Cut(level_index, level_index)
	ASSERT(length(level_ids) == length(x_min) == length(x_max) == length(y_min) == length(y_max) == length(level_z))

/datum/ssdaycycle_registered/proc/get_level_column(var/level_index)
	if(daycolumn_x < x_min[level_index] || daycolumn_x >= x_max[level_index])
		return //Don't add turfs until daycolumn is within the actual level
	. = block(locate(daycolumn_x, y_min[level_index], level_z[level_index]), locate(daycolumn_x, y_max[level_index], level_z[level_index]))

/datum/ssdaycycle_registered/proc/increment_column()
	if(daycolumn_x >= world.maxx)
		is_applying_night = !is_applying_night
		daycolumn_x = 1
	else
		daycolumn_x++
	time_last_column_update = REALTIMEOFDAY
	return daycolumn_x

/datum/ssdaycycle_registered/proc/update_all_daycolumns()
	for(var/i = 1 to length(level_ids))
		update_level_daycolumn(i)
	increment_column()

///Updates the day columns on a specific level we got
/datum/ssdaycycle_registered/proc/update_level_daycolumn(var/level_index)
	var/list/turfs = get_level_column(level_index)
	var/datum/level_data/LD = SSmapping.levels_by_id[level_ids[level_index]]
	var/light_color         = LD.ambient_light_color
	var/light_intensity     = is_applying_night? 0.1 : LD.ambient_light_level

	for(var/turf/T in turfs)
		if (light_intensity)
			T.set_ambient_light(light_color, light_intensity)
		else
			T.clear_ambient_light()