/turf/floor/natural/proc/can_draw_edge_over(turf/floor/natural/turf_to_check)
	if(istype(turf_to_check))
		var/my_height    = get_physical_height()
		var/their_height = turf_to_check.get_physical_height()
		// Uppermost turfs draw over lower turfs if there is a serious difference.
		if(my_height != their_height)
			return my_height > their_height
		// Use edge layer if we're within height range.
		return icon_edge_layer > turf_to_check.icon_edge_layer
	return TRUE

/turf/floor/natural/update_floor_icon(update_neighbors)

	if(flooring)
		return ..()

	if(icon_edge_layer >= 0)

		var/my_height = get_physical_height()
		var/neighbors = 0
		for(var/direction in global.cardinal)

			var/turf/floor/natural/turf_to_check = get_step_resolving_mimic(src, direction)
			if(!isturf(turf_to_check) || turf_to_check.density)
				continue

			// We consider adjacent same-type turfs within our height range to be neighbors.
			if(istype(turf_to_check, type) && my_height == turf_to_check.get_physical_height())
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

				var/turf/floor/natural/turf_to_check = get_step_resolving_mimic(src, direction)
				if(!istype(turf_to_check) || turf_to_check.density)
					continue

				if(istype(turf_to_check, type) && my_height == turf_to_check.get_physical_height())
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
