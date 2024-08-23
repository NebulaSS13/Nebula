/turf/floor
	var/static/HEIGHT_OFFSET_RANGE = (world.icon_size - 16)
	/// A cache for full trench shadow images, keyed by shadow_alpha.
	VAR_PRIVATE/static/list/_height_shadow_cache = list()
	/// A cache for north-edge trench shadow images, keyed by shadow_alpha.
	VAR_PRIVATE/static/list/_height_north_shadow_cache = list()
	/// A cache for trench images, keyed by icon and then by color.
	VAR_PRIVATE/static/list/_trench_image_cache = list()

/turf/floor/proc/get_trench_icon()
	var/check_icon = (istype(flooring) && flooring.icon) || icon
	if(check_icon && check_state_in_icon("trench", check_icon))
		return check_icon

/turf/floor/proc/update_height_appearance()

	layer = TURF_LAYER
	if(istype(flooring) && !flooring.render_trenches) // TODO: Update pool tiles/edges to behave properly with this new system.
		return FALSE

	var/my_height = get_physical_height()
	if(my_height < 0)

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
				var/trench_color = isatom(neighbor) ? neighbor.color : color
				var/trench_icon_key = "[ref(trench_icon)][trench_color]"
				if(!_trench_image_cache[trench_icon_key])
					_trench_image_cache[trench_icon_key] = I = image(icon = trench_icon, icon_state = "trench")
					I.pixel_z = world.icon_size
					I.appearance_flags |= RESET_COLOR | RESET_ALPHA
					I.color = trench_color
				add_overlay(I)

				// look up a shadow for our shadow_alpha in the cache, creating one if needed
				I = _height_north_shadow_cache[shadow_alpha_key]
				if(!I)
					_height_north_shadow_cache[shadow_alpha_key] = I = image(icon = 'icons/effects/height_shadow.dmi', icon_state = "northedge")
					I.pixel_z = world.icon_size
					I.color = COLOR_BLACK
					I.alpha = shadow_alpha
					I.appearance_flags |= RESET_COLOR | RESET_ALPHA
				add_overlay(I)

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

	update_height_appearance()

	compile_overlays()

	if(update_neighbors)
		for(var/turf/floor/F in orange(src, 1))
			F.queue_ao()
			F.queue_icon_update()

/turf/floor/proc/update_floor_icon(update_neighbors)
	if(istype(flooring))
		flooring.update_turf_icon(src)

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
