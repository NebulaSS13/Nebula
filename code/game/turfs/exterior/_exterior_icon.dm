/turf/exterior
	var/static/HEIGHT_OFFSET_RANGE = (world.icon_size - 16)

/turf/exterior/proc/can_draw_edge_over(turf/exterior/turf_to_check)
	if(istype(turf_to_check))
		var/my_height    = get_physical_height()
		var/their_height = turf_to_check.get_physical_height()
		// Uppermost turfs draw over lower turfs if there is a serious difference.
		if(my_height != their_height)
			return my_height > their_height
		// Use edge layer if we're within height range.
		return icon_edge_layer > turf_to_check.icon_edge_layer
	return TRUE

/turf/exterior/on_update_icon()
	. = ..() // Recalc AO and flooding overlay.
	cut_overlays()
	if(LAZYLEN(decals))
		add_overlay(decals)

	if(height < 0)

		var/height_ratio = clamp(abs(height) / FLUID_DEEP, 0, 1)
		default_pixel_z = -(min(HEIGHT_OFFSET_RANGE, round(HEIGHT_OFFSET_RANGE * height_ratio)))
		pixel_z = default_pixel_z
		layer = UNDER_TURF_LAYER + ((1-height_ratio) * 0.01)

		var/shadow_alpha = 80 * height_ratio
		var/image/I = image(icon = 'icons/effects/height_shadow.dmi', icon_state = "full")
		I.color = COLOR_BLACK
		I.alpha = shadow_alpha
		I.appearance_flags |= RESET_COLOR | RESET_ALPHA
		add_overlay(I)

		// Draw a cliff wall if we have a northern neighbor that isn't part of our trench.
		var/turf/neighbor = get_step_resolving_mimic(src, NORTH)
		if(!istype(neighbor) || (neighbor.get_physical_height() > height))
			I = image(icon = icon, icon_state = "trench")
			I.pixel_z = world.icon_size
			add_overlay(I)
			I = image(icon = 'icons/effects/height_shadow.dmi', icon_state = "northedge")
			I.pixel_z = world.icon_size
			I.color = COLOR_BLACK
			I.alpha = shadow_alpha
			I.appearance_flags |= RESET_COLOR | RESET_ALPHA
			add_overlay(I)

	else

		layer = TURF_LAYER

	if(icon_edge_layer >= 0)

		var/neighbors = 0
		for(var/direction in global.cardinal)

			var/turf/exterior/turf_to_check = get_step_resolving_mimic(src, direction)
			if(!isturf(turf_to_check) || turf_to_check.density)
				continue

			// We consider adjacent same-type turfs within our height range to be neighbors.
			if(istype(turf_to_check, type) && height == turf_to_check.get_physical_height())
				neighbors |= direction
				continue

			if(can_draw_edge_over(turf_to_check))
				var/image/I = image(icon, "edge[direction][icon_edge_states > 0 ? rand(0, icon_edge_states) : ""]")
				I.layer = layer + icon_edge_layer
				switch(direction)
					if(NORTH)
						I.pixel_y += world.icon_size
					if(SOUTH)
						I.pixel_y -= world.icon_size
					if(EAST)
						I.pixel_x += world.icon_size
					if(WEST)
						I.pixel_x -= world.icon_size
				add_overlay(I)

		if(icon_has_corners)
			for(var/direction in global.cornerdirs)

				var/turf/exterior/turf_to_check = get_step_resolving_mimic(src, direction)
				if(!istype(turf_to_check) || turf_to_check.density)
					continue

				if(istype(turf_to_check, type) && height == turf_to_check.get_physical_height())
					continue

				if(can_draw_edge_over(turf_to_check))
					var/draw_state
					var/res = (neighbors & direction)
					if(res == 0)
						draw_state = "edge[direction]"
					else if(res == direction)
						draw_state = "corner[direction]"
					if(draw_state && check_state_in_icon(draw_state, icon))
						var/image/I = image(icon, draw_state)
						I.layer = layer + icon_edge_layer
						if(direction & NORTH)
							I.pixel_y += world.icon_size
						else if(direction & SOUTH)
							I.pixel_y -= world.icon_size
						if(direction & EAST)
							I.pixel_x += world.icon_size
						else if(direction & WEST)
							I.pixel_x -= world.icon_size
						add_overlay(I)

	compile_overlays()
