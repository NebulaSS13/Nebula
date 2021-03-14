var/list/flooring_cache = list()

/turf/simulated/floor/on_update_icon(var/update_neighbors)

	. = ..()
	cut_overlays()
	if(lava)
		return

	var/has_smooth = 0 //This is just the has_border bitfield inverted for easier logic

	if(flooring)
		// Set initial icon and strings.
		SetName(flooring.name)
		desc = flooring.desc
		icon = flooring.icon
		color = flooring.color

		if(flooring_override)
			icon_state = flooring_override
		else
			icon_state = flooring.icon_base
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		// Apply edges, corners, and inner corners.
		var/has_border = 0
		//Check the cardinal turfs
		for(var/step_dir in GLOB.cardinal)
			var/turf/simulated/floor/T = get_step(src, step_dir)
			var/is_linked = flooring.symmetric_test_link(src, T)

			//Alright we've figured out whether or not we smooth with this turf
			if (!is_linked)
				has_border |= step_dir

				//Now, if we don't, then lets add a border
				add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir, (flooring.flags & TURF_HAS_EDGES)))

		has_smooth = ~(has_border & (NORTH | SOUTH | EAST | WEST))

		if(flooring.can_paint && decals && decals.len)
			add_overlay(decals)

		//We can only have inner corners if we're smoothed with something
		if (has_smooth && flooring.flags & TURF_HAS_INNER_CORNERS)
			for(var/direction in GLOB.cornerdirs)
				if((has_smooth & direction) == direction)
					if(!flooring.symmetric_test_link(src, get_step(src, direction)))
						add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-corner-[direction]", "[flooring.icon_base]_corners", direction))

		//Next up, outer corners
		if (has_border && flooring.flags & TURF_HAS_CORNERS)
			for(var/direction in GLOB.cornerdirs)
				if((has_border & direction) == direction)
					if(!flooring.symmetric_test_link(src, get_step(src, direction)))
						add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[direction]", "[flooring.icon_base]_edges", direction,(flooring.flags & TURF_HAS_EDGES)))

	if(decals && decals.len)
		for(var/image/I in decals)
			if(I.layer != DECAL_PLATING_LAYER)
				continue
			add_overlay(I)

	if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
		icon = 'icons/turf/flooring/plating.dmi'
		icon_state = "dmg[rand(1,4)]"
	else if(flooring)
		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			add_overlay(get_damage_overlay("broken[broken]", BLEND_MULTIPLY))
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			add_overlay(get_damage_overlay("burned[burnt]"))

	if(update_neighbors)
		for(var/turf/simulated/floor/F in orange(src, 1))
			F.queue_ao(FALSE)
			F.update_icon()

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE)
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

/turf/proc/get_damage_overlay(var/overlay_state, var/blend, var/damage_overlay_icon = 'icons/turf/flooring/damage.dmi')
	var/cache_key = "[icon]-[overlay_state]"
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = damage_overlay_icon, icon_state = overlay_state)
		if(blend)
			I.blend_mode = blend
		I.layer = DECAL_LAYER
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/decl/flooring/proc/test_link(var/turf/origin, var/turf/T)
	var/is_linked = FALSE
	if(istype(origin) && istype(T))
		//is_wall is true for wall turfs and for floors containing a low wall
		if(T.is_wall())
			if(wall_smooth == SMOOTH_ALL)
				is_linked = TRUE
		//If is_hole is true, then it's space or openspace
		else if(T.is_open())
			if(space_smooth == SMOOTH_ALL)
				is_linked = TRUE

		//If we get here then its a normal floor
		else if (T.is_floor())
			var/turf/simulated/floor/t = T
			//Check for window frames.
			if(wall_smooth == SMOOTH_ALL)
				for(var/obj/structure/wall_frame/WF in T.contents)
					is_linked = TRUE
			//If the floor is the same as us,then we're linked,
			if (istype(src, t.flooring))
				is_linked = TRUE
			else if (floor_smooth == SMOOTH_ALL)
				is_linked = TRUE
			else if (floor_smooth != SMOOTH_NONE)
				//If we get here it must be using a whitelist or blacklist
				if (floor_smooth == SMOOTH_WHITELIST)
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							//Found a match on the list
							is_linked = TRUE
							break
				else if(floor_smooth == SMOOTH_BLACKLIST)
					is_linked = TRUE //Default to true for the blacklist, then make it false if a match comes up
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							//Found a match on the list
							is_linked = FALSE
							break
	return is_linked

/decl/flooring/proc/symmetric_test_link(var/turf/A, var/turf/B)
	return test_link(A, B) && test_link(B,A)
