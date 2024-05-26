/turf/exterior/on_update_icon()
	. = ..() // Recalc AO and flooding overlay.
	cut_overlays()
	if(LAZYLEN(decals))
		add_overlay(decals)

	if(icon_edge_layer < 0)
		return

	var/neighbors = 0
	for(var/direction in global.cardinal)
		var/turf/exterior/turf_to_check = get_step_resolving_mimic(src, direction)
		if(!istype(turf_to_check) || turf_to_check.density)
			continue
		if(istype(turf_to_check, type))
			neighbors |= direction
			continue
		if(!istype(turf_to_check) || icon_edge_layer > turf_to_check.icon_edge_layer)
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
			if(!istype(turf_to_check) || turf_to_check.density || istype(turf_to_check, type))
				continue

			if(icon_edge_layer > turf_to_check.icon_edge_layer)
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
