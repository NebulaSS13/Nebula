/turf/floor
	var/static/HEIGHT_OFFSET_RANGE = (world.icon_size - 16)
	/// A cache for full trench shadow images, keyed by shadow_alpha.
	VAR_PRIVATE/static/list/_height_shadow_cache = list()
	/// A cache for north-edge trench shadow images, keyed by shadow_alpha.
	VAR_PRIVATE/static/list/_height_north_shadow_cache = list()
	/// A cache for trench images, keyed by icon and then by color.
	VAR_PRIVATE/static/list/_trench_image_cache = list()

/turf/floor/proc/can_draw_edge_over(turf/floor/turf_to_check)
	if(istype(turf_to_check))
		var/my_height    = get_physical_height()
		var/their_height = turf_to_check.get_physical_height()
		// Uppermost turfs draw over lower turfs if there is a serious difference.
		if(my_height != their_height)
			return my_height > their_height
		// Use edge layer if we're within height range.
		return can_layer_over(turf_to_check)
	return TRUE

/turf/floor/proc/can_layer_over(turf/floor/turf_to_check)
	if(!istype(turf_to_check))
		return FALSE
	var/decl/flooring/my_flooring = get_topmost_flooring()
	if(!istype(my_flooring) || my_flooring.icon_edge_layer == FLOOR_EDGE_NONE)
		return FALSE
	var/decl/flooring/their_flooring = turf_to_check.get_topmost_flooring()
	if(!istype(their_flooring))
		return TRUE
	if(their_flooring?.type == my_flooring.neighbour_type)
		return FALSE
	return my_flooring.icon_edge_layer > their_flooring.icon_edge_layer

/turf/floor/proc/get_trench_icon()
	var/decl/flooring/flooring = get_base_flooring() || get_topmost_flooring()
	if(istype(flooring) && flooring.icon && check_state_in_icon("trench", flooring.icon))
		return flooring.icon

/turf/floor/proc/update_height_appearance()

	var/decl/flooring/flooring = get_topmost_flooring()
	if(istype(flooring))
		layer = flooring.floor_layer
	else
		layer = initial(layer)

	if(istype(flooring) && !flooring.render_trenches) // TODO: Update pool tiles/edges to behave properly with this new system.
		default_pixel_z = initial(default_pixel_z)
		pixel_z = default_pixel_z
		return FALSE

	var/my_height = get_physical_height()
	if(my_height >= 0)
		default_pixel_z = initial(default_pixel_z)
	else
		var/height_ratio = clamp(abs(my_height) / FLUID_DEEP, 0, 1)
		default_pixel_z = -(min(HEIGHT_OFFSET_RANGE, round(HEIGHT_OFFSET_RANGE * height_ratio)))
		pixel_z = default_pixel_z
		layer = UNDER_TURF_LAYER + ((1-height_ratio) * 0.01)

		var/shadow_alpha = floor(80 * height_ratio)
		var/shadow_alpha_key = num2text(shadow_alpha)
		// look up a shadow for our shadow_alpha in the cache, creating one if needed
		var/image/I = _height_shadow_cache[shadow_alpha_key]
		if(!I)
			_height_shadow_cache[shadow_alpha_key] = I = image(icon = 'icons/effects/height_shadow.dmi', icon_state = "full")
			I.color = COLOR_BLACK
			I.alpha = shadow_alpha
			I.appearance_flags |= RESET_COLOR | RESET_ALPHA
		add_overlay(I)

		// Draw a cliff wall if we have a northern neighbor that isn't part of our trench.
		var/turf/floor/neighbor = get_step_resolving_mimic(src, NORTH)
		if(isturf(neighbor) && neighbor.is_open())
			return

		if(!istype(neighbor) || (neighbor.get_physical_height() > my_height))

			var/trench_icon = (istype(neighbor) && neighbor.get_trench_icon()) || get_trench_icon()
			if(trench_icon)
				// cache the trench image, keyed by icon and color
				var/trench_color = isatom(neighbor) ? neighbor.get_color() : get_color()
				var/trench_icon_key = "[ref(trench_icon)][trench_color]"
				I = _trench_image_cache[trench_icon_key]
				if(!I)
					I = image(icon = trench_icon, icon_state = "trench")
					I.pixel_z = world.icon_size
					I.appearance_flags |= RESET_COLOR | RESET_ALPHA
					I.color = trench_color
					_trench_image_cache[trench_icon_key] = I
				add_overlay(I)

			// look up a shadow for our shadow_alpha in the cache, creating one if needed
			I = _height_north_shadow_cache[shadow_alpha_key]
			if(!I)
				I = image(icon = 'icons/effects/height_shadow.dmi', icon_state = "northedge")
				I.pixel_z = world.icon_size
				I.color = COLOR_BLACK
				I.alpha = shadow_alpha
				I.appearance_flags |= RESET_COLOR | RESET_ALPHA
				_height_north_shadow_cache[shadow_alpha_key] = I
			add_overlay(I)
	pixel_z = default_pixel_z

/turf/floor/on_update_icon()
	. = ..()

	color = get_color()

	cut_overlays()
	update_height_appearance() // Also refreshes out base layer.
	update_floor_icon()

	for(var/image/I in decals)
		if(I.layer < layer)
			continue
		add_overlay(I)

	compile_overlays()

/turf/floor/proc/update_floor_strings()
	var/decl/flooring/flooring = get_topmost_flooring()
	if(istype(flooring))
		SetName(flooring.name)
		desc = flooring.desc
	else
		SetName(initial(name))
		desc = initial(desc)

/turf/floor/proc/update_floor_icon()
	var/decl/flooring/use_flooring = get_topmost_flooring()
	if(istype(use_flooring))
		use_flooring.update_turf_icon(src)

/turf/floor/proc/is_floor_broken()
	var/decl/flooring/flooring = get_topmost_flooring()
	return !isnull(_floor_broken) && (!istype(flooring) || length(flooring.broken_states))

/turf/floor/proc/is_floor_burned()
	var/decl/flooring/flooring = get_topmost_flooring()
	return !isnull(_floor_burned) && (!istype(flooring) || length(flooring.burned_states))

/turf/floor/proc/is_floor_damaged()
	return is_floor_broken() || is_floor_burned()

/turf/floor/proc/set_floor_broken(new_broken, skip_update)

	var/decl/flooring/flooring = get_topmost_flooring()
	if(!istype(flooring) || !length(flooring.broken_states))
		return FALSE
	if(new_broken && (!istext(new_broken) || !(new_broken in flooring.broken_states)))
		new_broken = pick(flooring.broken_states)
	if(_floor_broken != new_broken)
		_floor_broken = new_broken
		if(!skip_update)
			queue_icon_update()
		return TRUE
	return FALSE

/turf/floor/proc/set_floor_burned(new_burned, skip_update)

	var/decl/flooring/flooring = get_topmost_flooring()
	if(!istype(flooring) || !length(flooring.burned_states))
		return FALSE
	if(new_burned && (!istext(new_burned) || !(new_burned in flooring.burned_states)))
		new_burned = pick(flooring.burned_states)
	if(_floor_burned != new_burned)
		_floor_burned = new_burned
		if(!skip_update)
			queue_icon_update()
		return TRUE
	return FALSE

/decl/flooring/proc/test_link(var/turf/origin, var/turf/opponent)
	if(!istype(origin) || !istype(opponent))
		return FALSE

	// Just a normal floor
	if (istype(opponent, /turf/floor))
		var/turf/floor/floor_opponent = opponent
		var/decl/flooring/opponent_flooring = floor_opponent.get_topmost_flooring()
		if (floor_smooth == SMOOTH_ALL)
			return TRUE
		//If the floor is the same as us,then we're linked,
		else if (istype(opponent_flooring, neighbour_type))
			return TRUE
		//If we get here it must be using a whitelist or blacklist
		else if (floor_smooth == SMOOTH_WHITELIST)
			if (flooring_whitelist[opponent_flooring.type])
				//Found a match on the typecache
				return TRUE
		else if(floor_smooth == SMOOTH_BLACKLIST)
			if (flooring_blacklist[opponent_flooring.type]) {EMPTY_BLOCK_GUARD} else
				//No match on the typecache
				return TRUE
		//Check for window frames.
		if (wall_smooth == SMOOTH_ALL)
			if(locate(/obj/structure/wall_frame) in opponent)
				return TRUE
	// Wall turf
	else if(opponent.is_wall())
		if(wall_smooth == SMOOTH_ALL)
			return TRUE
	//If is_open is true, then it's space or openspace
	else if(opponent.is_open())
		if(space_smooth == SMOOTH_ALL)
			return TRUE
	return FALSE

/decl/flooring/proc/symmetric_test_link(var/turf/A, var/turf/B)
	return test_link(A, B) && test_link(B,A)
