/turf/floor/on_update_icon(var/update_neighbors)
	. = ..()
	cut_overlays()
	update_floor_icon(update_neighbors)

	for(var/image/I in decals)
		if(I.layer < layer)
			continue
		add_overlay(I)

	if(is_floor_broken())
		add_overlay(get_turf_damage_overlay(_floor_broken))
	if(is_floor_burned())
		add_overlay(get_turf_damage_overlay(_floor_burned))
	compile_overlays()

	if(update_neighbors)
		for(var/turf/floor/F in orange(src, 1))
			F.queue_ao(FALSE)
			F.queue_icon_update()


/turf/floor/proc/update_floor_icon(update_neighbors)
	if(istype(flooring))
		flooring.update_turf_icon(src)
		return
	// Set initial icon and strings.
	SetName(initial(name))
	desc       = initial(desc)
	icon       = initial(icon)
	icon_state = initial(icon_state)
	color      = initial(color)
	flooring_override = null

/turf/floor/proc/is_floor_broken()
	return !isnull(_floor_broken) && (!flooring || (flooring.flags & TURF_CAN_BREAK))

/turf/floor/proc/is_floor_burned()
	return !isnull(_floor_burned) && (!flooring || (flooring.flags & TURF_CAN_BURN))

/turf/floor/proc/is_floor_damaged()
	return is_floor_broken() || is_floor_burned()

/turf/floor/proc/set_floor_broken(new_broken, skip_update)

	if(flooring && !(flooring.flags & TURF_CAN_BREAK))
		return FALSE

	// Hardcoded because they're bundled into the same icon file at the moment.
	var/static/list/broken_states = list(
		"broken0",
		"broken1",
		"broken2",
		"broken3",
		"broken4"
	)
	if(new_broken && (!istext(new_broken) || !(new_broken in broken_states)))
		new_broken = "broken[rand(0,4)]"
	if(_floor_broken != new_broken)
		_floor_broken = new_broken
		if(!skip_update)
			queue_icon_update()
		return TRUE
	return FALSE

/turf/floor/proc/set_floor_burned(new_burned, skip_update)

	if(flooring && !(flooring.flags & TURF_CAN_BURN))
		return FALSE

	// Hardcoded because they're bundled into the same icon file at the moment.
	var/static/list/burned_states = list(
		"burned0",
		"burned1"
	)
	if(new_burned && (!istext(new_burned) || !(new_burned in burned_states)))
		new_burned = "burned[rand(0,1)]"
	if(_floor_burned != new_burned)
		_floor_burned = new_burned
		if(!skip_update)
			queue_icon_update()
		return TRUE
	return FALSE

/turf/proc/get_turf_damage_overlay_icon()
	return 'icons/turf/flooring/damage.dmi'

/turf/proc/get_turf_damage_overlay(var/overlay_state)
	var/damage_overlay_icon = get_turf_damage_overlay_icon()
	var/cache_key = "[icon]-[overlay_state]"
	if(!global.flooring_cache[cache_key])
		var/image/I = image(icon = damage_overlay_icon, icon_state = overlay_state)
		I.blend_mode = BLEND_MULTIPLY
		I.layer = DECAL_LAYER
		global.flooring_cache[cache_key] = I
	return global.flooring_cache[cache_key]

/decl/flooring/proc/test_link(var/turf/origin, var/turf/opponent)
	var/is_linked = FALSE
	if(istype(origin) && istype(opponent))
		//is_wall is true for wall turfs and for floors containing a low wall
		if(opponent.is_wall())
			if(wall_smooth == SMOOTH_ALL)
				is_linked = TRUE
		//If is_hole is true, then it's space or openspace
		else if(opponent.is_open())
			if(space_smooth == SMOOTH_ALL)
				is_linked = TRUE

		//If we get here then its a normal floor
		else if (istype(opponent, /turf/floor))
			var/turf/floor/floor_opponent = opponent
			//If the floor is the same as us,then we're linked,
			if (istype(src, floor_opponent.flooring))
				is_linked = TRUE
			else if (floor_smooth == SMOOTH_ALL)
				is_linked = TRUE
			else if (floor_smooth != SMOOTH_NONE)
				//If we get here it must be using a whitelist or blacklist
				if (floor_smooth == SMOOTH_WHITELIST)
					if (flooring_whitelist[floor_opponent.flooring.type])
						//Found a match on the typecache
						is_linked = TRUE
				else if(floor_smooth == SMOOTH_BLACKLIST)
					is_linked = TRUE //Default to true for the blacklist, then make it false if a match comes up
					if (flooring_blacklist[floor_opponent.flooring.type])
						//Found a match on the typecache
						is_linked = FALSE
			//Check for window frames.
			if (!is_linked && wall_smooth == SMOOTH_ALL)
				if(locate(/obj/structure/wall_frame) in opponent)
					is_linked = TRUE
	return is_linked

/decl/flooring/proc/symmetric_test_link(var/turf/A, var/turf/B)
	return test_link(A, B) && test_link(B,A)
