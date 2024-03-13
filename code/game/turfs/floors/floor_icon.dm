var/global/list/flooring_cache = list()

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

	if(update_neighbors)
		for(var/turf/floor/F in orange(src, 1))
			F.queue_ao(FALSE)
			F.queue_icon_update()

/turf/floor/proc/update_floor_icon(update_neighbors)
	if(!flooring)
		return // This implies we're plating.
	// Set initial icon and strings.
	SetName(flooring.name)
	desc  = flooring.desc
	if(icon != flooring.icon)
		icon  = flooring.icon
	if(color != flooring.color)
		color = flooring.color
	if(!flooring_override)
		flooring_override = flooring.icon_base
		if(flooring.has_base_range)
			flooring_override = "[flooring_override][rand(0,flooring.has_base_range)]"
	if(icon_state != flooring_override)
		icon_state = flooring_override

	// Apply edges, corners, and inner corners.
	var/has_border = 0
	//Check the cardinal turfs
	for(var/step_dir in global.cardinal)
		var/turf/floor/T = get_step(src, step_dir)
		var/is_linked = flooring.symmetric_test_link(src, T)
		//Alright we've figured out whether or not we smooth with this turf
		if (!is_linked)
			has_border |= step_dir
			//Now, if we don't, then lets add a border
			if(check_state_in_icon("[flooring.icon_base]_edges", flooring.icon))
				add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir, (flooring.flags & TURF_HAS_EDGES)))
	var/has_smooth = ~(has_border & (NORTH | SOUTH | EAST | WEST))
	if(flooring.can_paint && LAZYLEN(decals))
		add_overlay(decals.Copy())
	//We can only have inner corners if we're smoothed with something
	if (has_smooth && flooring.flags & TURF_HAS_INNER_CORNERS)
		for(var/direction in global.cornerdirs)
			if((has_smooth & direction) == direction)
				if(!flooring.symmetric_test_link(src, get_step(src, direction)) && check_state_in_icon("[flooring.icon_base]_corners", flooring.icon))
					add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-corner-[direction]", "[flooring.icon_base]_corners", direction))
	//Next up, outer corners
	if (has_border && flooring.flags & TURF_HAS_CORNERS)
		for(var/direction in global.cornerdirs)
			if((has_border & direction) == direction)
				if(!flooring.symmetric_test_link(src, get_step(src, direction)) && check_state_in_icon("[flooring.icon_base]_edges", flooring.icon))
					add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[direction]", "[flooring.icon_base]_edges", direction,(flooring.flags & TURF_HAS_EDGES)))

/turf/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		//External overlays will be offset out of this tile
		if (external)
			if (icon_dir & NORTH)
				I.pixel_y = world.icon_size
			else if (icon_dir & SOUTH)
				I.pixel_y = -world.icon_size
			if (icon_dir & WEST)
				I.pixel_x = -world.icon_size
			else if (icon_dir & EAST)
				I.pixel_x = world.icon_size
		I.layer = flooring.decal_layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

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
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = damage_overlay_icon, icon_state = overlay_state)
		I.blend_mode = BLEND_MULTIPLY
		I.layer = DECAL_LAYER
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

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
