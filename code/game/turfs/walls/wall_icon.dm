/turf/wall/proc/refresh_opacity()
	return set_opacity(!(!density || shutter_state == TRUE || (istype(material) && material.opacity < 0.5)))

/turf/wall/proc/update_material(var/update_neighbors)
	if(construction_stage != -1)
		if(reinf_material)
			construction_stage = 6
		else
			construction_stage = null
	if(!material)
		material = get_default_material()
	if(material)
		explosion_resistance = material.explosion_resistance
		hitsound = material.hitsound
	if(reinf_material)
		reinf_icon = islist(reinf_material.icon_reinf) ? pick(reinf_material.icon_reinf) : reinf_material.icon_reinf
		if(reinf_material.explosion_resistance > explosion_resistance)
			explosion_resistance = reinf_material.explosion_resistance
	else
		reinf_icon = null
	update_strings()
	refresh_opacity()
	SSradiation.resistance_cache.Remove(src)
	if(update_neighbors)
		var/iterate_turfs = list()
		for(var/direction in global.alldirs)
			var/turf/wall/wall = get_step_resolving_mimic(src, direction)
			if(istype(wall))
				wall.wall_connections = null
				wall.other_connections = null
				iterate_turfs += wall
		for(var/turf/wall/wall as anything in iterate_turfs)
			wall.lazy_update_icon()
	else
		wall_connections = null
		other_connections = null
	lazy_update_icon()

/turf/wall/proc/paint_wall(var/new_paint_color)
	paint_color = new_paint_color
	update_icon()

/turf/wall/proc/stripe_wall(var/new_paint_color)
	stripe_color = new_paint_color
	update_icon()

/turf/wall/proc/update_strings()
	if(reinf_material)
		SetName("reinforced [material.solid_name] [material.wall_name]")
		desc = "It seems to be a section of hull reinforced with [reinf_material.solid_name] and plated with [material.solid_name]."
	else
		SetName("[material.solid_name] [material.wall_name]")
		desc = "It seems to be a section of hull plated with [material.solid_name]."

/turf/wall/proc/get_wall_icon()
	. = (istype(material) && material.icon_base) || 'icons/turf/walls/solid.dmi'

/turf/wall/proc/apply_reinf_overlay()
	. = istype(reinf_material) && reinf_icon

/// Gets the base wall colour for icon rendering. Can be overridden on wall subtypes. Not equivalent to get_color().
/// Should only be used in places where material is known to be set, e.g. update_wall_icon().
/turf/wall/proc/get_base_color()
	return material.color

/// Gets the reinforcement colour. Can be overridden so that some wall types don't apply paint colour to their reinforcements.
/turf/wall/proc/get_reinf_color()
	return paint_color || reinf_material?.color

/turf/wall/proc/refresh_connections()
	if(wall_connections && other_connections)
		return
	var/list/wall_dirs =  list()
	var/list/other_dirs = list()
	for(var/stepdir in global.alldirs)
		var/turf/T = get_step_resolving_mimic(src, stepdir)
		if(!T)
			continue
		if(istype(T, /turf/wall))
			switch(can_join_with(T))
				if(0)
					continue
				if(1)
					wall_dirs += stepdir
				if(2)
					wall_dirs += stepdir
					other_dirs += stepdir

		if(handle_structure_blending)
			var/success = 0
			for(var/O in T)
				for(var/blend_type in global.wall_blend_objects)
					if(istype(O, blend_type))
						success = TRUE
						break
				for(var/nb_type in global.wall_noblend_objects)
					if(istype(O, nb_type))
						success = FALSE
						break
				if(success)
					wall_dirs += get_dir(src, T)
					if(get_dir(src, T) in global.cardinal)
						var/blendable = FALSE
						for(var/fb_type in global.wall_fullblend_objects)
							if(istype(O, fb_type))
								blendable = TRUE
								break
						if(!blendable)
							other_dirs += get_dir(src, T)
					break
	wall_connections = dirs_to_corner_states(wall_dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/turf/wall/proc/update_wall_icon()
	var/material_icon_base = get_wall_icon()
	var/base_color = get_base_color()

	var/new_icon
	var/new_icon_state
	var/new_color

	if(!density)
		new_icon = material_icon_base
		new_icon_state = "fwall_open"
		new_color = base_color
	else
		new_icon = get_combined_wall_icon(wall_connections, other_connections, material_icon_base, base_color, paint_color, stripe_color, (material.wall_flags & WALL_HAS_EDGES) && (stripe_color || base_color))
		new_icon_state = ""
		new_color = null

	if(icon != new_icon)
		icon = new_icon
	if(icon_state != new_icon_state)
		icon_state = new_icon_state
	if(color != new_color)
		color = new_color

	if(apply_reinf_overlay())
		var/image/I
		var/reinf_color = get_reinf_color()
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/walls/_construction_overlays.dmi', "[construction_stage]")
			I.color = reinf_color
			add_overlay(I)
		else
			if(reinf_material.use_reinf_state)
				I = image(reinf_icon, reinf_material.use_reinf_state)
				I.color = reinf_color
			else
				I = image(_get_wall_subicon(reinf_icon, wall_connections, reinf_color))
			add_overlay(I)

// Update icon on ambient light change, for shutter overlays.
/turf/wall/update_ambient_light_from_z_or_area()
	. = ..()
	if(shutter_state)
		queue_icon_update()

/turf/wall/on_update_icon()
	. = ..()
	cut_overlays()

	if(!istype(material))
		return

	refresh_connections()
	update_wall_icon()

	var/image/texture = material.get_wall_texture()
	if(texture)
		add_overlay(texture)

	if(!isnull(shutter_state) && shutter_icon)
		var/decl/material/shutter_mat = shutter_material || material
		var/new_light_dir // get the opposite direction associated with the strongest light
		var/light_str // the strength associated with new_light_dir
		var/new_light_color // get the color associated with the strongest light
		var/list/shutters
		var/list/connected = corner_states_to_dirs(wall_connections) | corner_states_to_dirs(other_connections) // merge the lists
		set_light(0) // disable our own light before we calculate light strength
		for(var/stepdir in global.cardinal)
			if(stepdir in connected)
				continue
			var/turf/neighbor = get_step_resolving_mimic(src, stepdir)
			if(!istype(neighbor) || neighbor.density)
				continue
			LAZYADD(shutters, image(shutter_icon, num2text(shutter_state), dir = stepdir))
			if(shutter_state)
				var/turf/other_neighbor = get_step_resolving_mimic(src, global.reverse_dir[stepdir])
				if(istype(other_neighbor))
					var/light_amt   = 255 * other_neighbor.get_lumcount()
					if(other_neighbor.lighting_overlay && light_amt > 0) // get_lumcount defaults to 0.5 if lighting_overlay is null
						if(!new_light_dir || light_str < light_amt / 255)
							new_light_dir = stepdir
							light_str = light_amt / 255
							new_light_color = other_neighbor.get_avg_color()
						var/image/light_overlay = emissive_overlay(shutter_icon, "glow", dir = stepdir, color = other_neighbor.get_avg_color())
						light_overlay.alpha = light_amt
						light_overlay.appearance_flags |= RESET_COLOR|RESET_ALPHA
						LAZYADD(shutters, light_overlay)
		// create a light cone in the direction of new_light_dir with color new_light_color
		if(new_light_dir)
			light_dir = new_light_dir
			set_light(7, light_str, new_light_color, LIGHT_WIDE)
		else
			light_dir = null
			set_light(0)

		if(length(shutters))
			var/image/shutter_image = new /image
			shutter_image.overlays = shutters
			shutter_image.color = shutter_mat.color
			shutter_image.appearance_flags |= RESET_COLOR|RESET_ALPHA
			add_overlay(shutter_image)

	if(damage != 0 && SSmaterials.wall_damage_overlays)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity
		add_overlay(SSmaterials.wall_damage_overlays[clamp(round(damage / integrity * DAMAGE_OVERLAY_COUNT) + 1, 1, DAMAGE_OVERLAY_COUNT)])

/turf/wall/proc/can_join_with(var/turf/wall/wall)
	if(unique_merge_identifier != wall.unique_merge_identifier)
		return 0
	else if(unique_merge_identifier)
		return 1
	else if(material && istype(wall.material))
		var/other_wall_icon = wall.get_wall_icon()
		if(get_wall_icon() == other_wall_icon)
			return 1
		if(material.wall_blend_icons[other_wall_icon])
			return 2
	return 0
