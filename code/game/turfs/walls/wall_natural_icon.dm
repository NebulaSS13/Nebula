// Somewhat simplified compared to base walls, but needs to take ramp slope into account.
/turf/wall/natural/refresh_connections()
	wall_connections = list()
	for(var/stepdir in global.alldirs)
		// Get the wall.
		var/turf/wall/natural/T = get_step_resolving_mimic(src, stepdir)
		if(!istype(T))
			continue
		if(ramp_slope_direction) // We are a ramp.
			// Adjacent ramps flowing in the same direction as us.
			if(ramp_slope_direction == T.ramp_slope_direction)
				wall_connections += stepdir
				continue
			// It's an adjacent non-ramp wall.
			if(!T.ramp_slope_direction)
				// It is behind us.
				if(stepdir & global.reverse_dir[ramp_slope_direction])
					wall_connections += stepdir
					continue
		else // We are a wall.
			// It is a wall.
			if(!T.ramp_slope_direction)
				wall_connections += stepdir
				continue
			// It's a ramp running away from us.
			if(stepdir & T.ramp_slope_direction)
				wall_connections += stepdir
				continue
	wall_connections = dirs_to_corner_states(wall_connections)

/turf/wall/natural/update_wall_icon()

	var/material_icon_base = get_wall_icon()
	var/base_color = material.color
	var/shine = 0

	if(material.reflectiveness > 0)
		var/shine_cache_key = "[material.reflectiveness]-[material.color]"
		shine = exterior_wall_shine_cache[shine_cache_key]
		if(isnull(shine))
			// patented formula based on color's value (in HSV)
			shine = clamp((material.reflectiveness * 0.01) * 255, 10, (0.6 * ReadHSV(RGBtoHSV(material.color))[3]))
			exterior_wall_shine_cache[shine_cache_key] = shine

	var/new_icon
	var/new_icon_state
	var/new_color

	if(ramp_slope_direction)

		// TODO: make this a check on flooring when floor unification is in.
		var/turf/floor_data = floor_type
		new_icon       = initial(floor_data.icon)
		new_icon_state = initial(floor_data.icon_state)
		new_color      = initial(floor_data.color)

		var/turf/wall/natural/neighbor = get_step(src, turn(ramp_slope_direction, -90))
		var/has_left_neighbor  = istype(neighbor) && neighbor.ramp_slope_direction == ramp_slope_direction
		neighbor = get_step(src, turn(ramp_slope_direction, 90))
		var/has_right_neighbor = istype(neighbor) && neighbor.ramp_slope_direction == ramp_slope_direction
		var/state = "ramp-single"
		if(has_left_neighbor && has_right_neighbor)
			state = "ramp-blend-full"
		else if(has_left_neighbor)
			state = "ramp-blend-left"
		else if(has_right_neighbor)
			state = "ramp-blend-right"
		var/image/I = image(material_icon_base, state, dir = ramp_slope_direction)
		I.color = base_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)
		if(shine)
			I = image(material_icon_base, "[state]-shine", dir = ramp_slope_direction)
			I.appearance_flags |= RESET_ALPHA
			I.alpha = shine
			add_overlay(I)
	else
		new_icon       = get_combined_wall_icon(wall_connections, null, material_icon_base, base_color, shine_value = shine)
		new_icon_state = ""
		new_color      = null

	if(icon_state != new_icon_state)
		icon_state = new_icon_state
	if(color != new_color)
		color = new_color
	if(icon != new_icon)
		icon = new_icon

/turf/wall/natural/on_update_icon()
	. = ..()
	if(ore_overlay)
		add_overlay(ore_overlay)
	if(excav_overlay)
		add_overlay(excav_overlay)
	if(archaeo_overlay)
		add_overlay(archaeo_overlay)
