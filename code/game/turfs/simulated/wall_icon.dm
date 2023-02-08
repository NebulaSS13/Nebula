/turf/simulated/wall/proc/update_material(var/update_neighbors)
	if(construction_stage != -1)
		if(reinf_material)
			construction_stage = 6
		else
			construction_stage = null
	if(!material)
		material = GET_DECL(get_default_material())
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
		for(var/turf/simulated/wall/W in RANGE_TURFS(src, 1))
			W.wall_connections = null
			W.other_connections = null
			iterate_turfs += W
		for(var/turf/simulated/wall/W as anything in iterate_turfs)
			W.update_icon()
	else
		wall_connections = null
		other_connections = null
		update_icon()

/turf/simulated/wall/proc/paint_wall(var/new_paint_color)
	paint_color = new_paint_color
	update_icon()

/turf/simulated/wall/proc/stripe_wall(var/new_paint_color)
	stripe_color = new_paint_color
	update_icon()

/turf/simulated/wall/proc/update_strings()
	if(reinf_material)
		SetName("reinforced [material.solid_name] [material.wall_name]")
		desc = "It seems to be a section of hull reinforced with [reinf_material.solid_name] and plated with [material.solid_name]."
	else
		SetName("[material.solid_name] [material.wall_name]")
		desc = "It seems to be a section of hull plated with [material.solid_name]."

/turf/simulated/wall/proc/get_default_material()
	. = DEFAULT_WALL_MATERIAL

/turf/simulated/wall/proc/set_material(var/decl/material/newmaterial, var/decl/material/newrmaterial, var/decl/material/newgmaterial)

	material = newmaterial
	if(ispath(material, /decl/material))
		material = GET_DECL(material)
	else if(!istype(material))
		PRINT_STACK_TRACE("Wall has been supplied non-material '[newmaterial]'.")
		material = GET_DECL(get_default_material())

	reinf_material = newrmaterial
	if(ispath(reinf_material, /decl/material))
		reinf_material = GET_DECL(reinf_material)
	else if(!istype(reinf_material))
		reinf_material = null

	girder_material = newgmaterial
	if(ispath(girder_material, /decl/material))
		girder_material = GET_DECL(girder_material)
	else if(!istype(girder_material))
		girder_material = null

	update_material()

/turf/simulated/wall/proc/get_wall_icon()
	. = (istype(material) && material.icon_base) || 'icons/turf/walls/solid.dmi'

/turf/simulated/wall/proc/apply_reinf_overlay()
	. = istype(reinf_material)

/turf/simulated/wall/on_update_icon()
	. = ..()
	cut_overlays()

	if(!istype(material))
		return

	if(!wall_connections || !other_connections)
		var/list/wall_dirs =  list()
		var/list/other_dirs = list()
		for(var/stepdir in global.alldirs)
			var/turf/T = get_step(src, stepdir)
			if(!T)
				continue
			if(istype(T, /turf/simulated/wall))
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
					for(var/b_type in global.wall_blend_objects)
						if(istype(O, b_type))
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

	var/material_icon_base = get_wall_icon()
	var/base_color = material.color
	if(!density)
		icon = material_icon_base
		icon_state = "fwall_open"
		color = base_color
	else
		icon = get_combined_wall_icon(wall_connections, other_connections, material_icon_base, base_color, paint_color, stripe_color, (material.wall_flags & WALL_HAS_EDGES) && (stripe_color || base_color))
		icon_state = ""
		color = null

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

	var/image/texture = material.get_wall_texture()
	if(texture)
		add_overlay(texture)

	if(damage != 0 && SSmaterials.wall_damage_overlays)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity
		add_overlay(SSmaterials.wall_damage_overlays[clamp(round(damage / integrity * DAMAGE_OVERLAY_COUNT) + 1, 1, DAMAGE_OVERLAY_COUNT)])

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(material && istype(W.material))
		var/other_wall_icon = W.get_wall_icon()
		if(material.wall_blend_icons[other_wall_icon])
			return 2
		if(get_wall_icon() == other_wall_icon)
			return 1
	return 0
