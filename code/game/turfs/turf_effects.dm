/turf/proc/get_wetness()
	if(!simulated)
		return 0
	var/atom/movable/wet_floor/wet_decal = locate() in src
	return wet_decal?.wetness || 0

/turf/proc/wet_floor(var/wet_val = 1, var/overwrite = FALSE)
	if(!simulated || is_flooded(absolute = TRUE) || get_fluid_depth() > FLUID_QDEL_POINT)
		return FALSE
	var/atom/movable/wet_floor/wet_decal = locate() in src
	if(wet_val < wet_decal?.wetness && !overwrite)
		return FALSE
	if(!wet_decal)
		wet_decal = new(src)
	wet_decal.wetness = wet_val
	wet_decal.wet_timer_id = addtimer(CALLBACK(wet_decal, TYPE_PROC_REF(/atom/movable/wet_floor, unwet_floor)), 8 SECONDS, (TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE))
	return TRUE

/turf/proc/unwet_floor(var/check_very_wet = TRUE)
	if(!simulated)
		return FALSE
	var/atom/movable/wet_floor/wet_decal = locate() in src
	if(!wet_decal)
		return FALSE
	if(check_very_wet && wet_decal.wetness >= 2)
		wet_decal.wetness--
		wet_decal.wet_timer_id = addtimer(CALLBACK(wet_decal, TYPE_PROC_REF(/atom/movable/wet_floor, unwet_floor)), 8 SECONDS, (TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE))
	else
		qdel(wet_decal)
	return TRUE

#define MAX_DIRT 101
/turf/proc/add_dirt(amount)
	if(!simulated)
		return FALSE
	var/obj/effect/decal/cleanable/dirt/dirt = locate() in src
	if(!dirt)
		dirt = new(src)
	dirt.dirt_amount = min(dirt.dirt_amount + amount, MAX_DIRT)
	return TRUE
#undef MAX_DIRT

/turf/proc/remove_dirt(amount)
	if(!simulated)
		return FALSE
	var/obj/effect/decal/cleanable/dirt/dirt = locate() in src
	if(!dirt)
		return FALSE
	dirt.dirt_amount = min(dirt.dirt_amount - amount, 0)
	if(dirt.dirt_amount)
		dirt.update_icon()
	else
		qdel(dirt)
	return TRUE

/turf/proc/get_dirt(amount)
	if(!simulated)
		return 0
	var/obj/effect/decal/cleanable/dirt/dirt = locate() in src
	return dirt?.dirt_amount || 0
