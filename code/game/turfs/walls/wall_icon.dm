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
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance
	update_strings()
	set_opacity(material.opacity >= 0.5)
	SSradiation.resistance_cache.Remove(src)
	if(update_neighbors)
		var/iterate_turfs = list()
		for(var/direction in global.alldirs)
			var/turf/wall/W = get_step_resolving_mimic(src, direction)
			if(istype(W))
				W.wall_connections = null
				W.other_connections = null
				iterate_turfs += W
		for(var/turf/wall/W as anything in iterate_turfs)
			W.update_icon()
	else
		wall_connections = null
		other_connections = null
	update_icon()

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
	. = istype(reinf_material)

/turf/wall/proc/refresh_connections()
	if(wall_connections && other_connections)
		return
	var/list/wall_dirs =  list()
	var/list/other_dirs = list()
	for(var/stepdir in global.alldirs)
		var/turf/T = get_step(src, stepdir)
		if(!T)
			continue
		if(istype(T, /turf/wall))
			switch(can_join_with(T))
				if(0)
					continue
				if(1)
					wall_dirs += get_dir(src, T)
				if(2)
					wall_dirs += get_dir(src, T)
					other_dirs += get_dir(src, T)

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
	var/base_color = material.color

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
		var/reinf_color = paint_color ? paint_color : reinf_material.color
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/walls/_construction_overlays.dmi', "[construction_stage]")
			I.color = reinf_color
			add_overlay(I)
		else
			if(reinf_material.use_reinf_state)
				I = image(reinf_material.icon_reinf, reinf_material.use_reinf_state)
				I.color = reinf_color
			else
				I = image(_get_wall_subicon(reinf_material.icon_reinf, wall_connections, reinf_color))
			add_overlay(I)

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

	if(damage != 0 && SSmaterials.wall_damage_overlays)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity
		add_overlay(SSmaterials.wall_damage_overlays[clamp(round(damage / integrity * DAMAGE_OVERLAY_COUNT) + 1, 1, DAMAGE_OVERLAY_COUNT)])

/turf/wall/proc/can_join_with(var/turf/wall/W)
	if(unique_merge_identifier != W.unique_merge_identifier)
		return 0
	else if(unique_merge_identifier)
		return 1
	else if(material && istype(W.material))
		var/other_wall_icon = W.get_wall_icon()
		if(material.wall_blend_icons[other_wall_icon])
			return 2
		if(get_wall_icon() == other_wall_icon)
			return 1
	return 0
