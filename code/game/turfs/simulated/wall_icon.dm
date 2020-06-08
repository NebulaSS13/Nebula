/turf/simulated/wall/proc/update_material()
	if(construction_stage != -1)
		if(reinf_material)
			construction_stage = 6
		else
			construction_stage = null
	if(!material)
		material = decls_repository.get_decl(get_default_material())
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance
	update_strings()
	set_opacity(material.opacity >= 0.5)
	SSradiation.resistance_cache.Remove(src)
	update_connections(1)
	queue_icon_update()

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
		material = decls_repository.get_decl(material)
	else if(!istype(material))
		crash_with("Wall has been supplied non-material '[newmaterial]'.")
		material = decls_repository.get_decl(get_default_material())

	reinf_material = newrmaterial
	if(ispath(reinf_material, /decl/material))
		reinf_material = decls_repository.get_decl(reinf_material)
	else if(!istype(reinf_material))
		reinf_material = null

	girder_material = newgmaterial
	if(ispath(girder_material, /decl/material))
		girder_material = decls_repository.get_decl(girder_material)
	else if(!istype(girder_material))
		girder_material = null

	update_material()

/turf/simulated/wall/proc/get_wall_state()
	. = material?.icon_base || "metal"

/turf/simulated/wall/proc/apply_reinf_overlay()
	. = !!reinf_material

/turf/simulated/wall/on_update_icon()

	. = ..()
	cut_overlays()

	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated; note that it is always of fixed length, so we must check for membership.
		generate_overlays()

	var/material_icon_base = get_wall_state()
	var/image/I
	var/base_color = paint_color ? paint_color : material.color
	if(!density)
		I = image(icon, "[material_icon_base]fwall_open")
		I.color = base_color
		add_overlay(I)
		return

	for(var/i = 1 to 4)
		I = image(icon, "[material_icon_base][wall_connections[i]]", dir = 1<<(i-1))
		I.color = base_color
		add_overlay(I)
		if(other_connections[i] != "0")
			I = image(icon, "[material_icon_base]_other[wall_connections[i]]", dir = 1<<(i-1))
			I.color = base_color
			add_overlay(I)

	if(apply_reinf_overlay())
		var/reinf_color = paint_color ? paint_color : reinf_material.color
		if(construction_stage != null && construction_stage < 6)
			I = image(icon, "reinf_construct-[construction_stage]")
			I.color = reinf_color
			add_overlay(I)
		else
			if("[reinf_material.icon_reinf]0" in icon_states(icon))
				// Directional icon
				for(var/i = 1 to 4)
					I = image(icon, "[reinf_material.icon_reinf][wall_connections[i]]", dir = 1<<(i-1))
					I.color = reinf_color
					add_overlay(I)
			else
				I = image(icon, reinf_material.icon_reinf)
				I.color = reinf_color
				add_overlay(I)
	var/image/texture = material.get_wall_texture()
	if(texture)
		add_overlay(texture)
	if(stripe_color)
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image(icon, "stripe_other[wall_connections[i]]", dir = 1<<(i-1))
			else
				I = image(icon, "stripe[wall_connections[i]]", dir = 1<<(i-1))
			I.color = stripe_color
			add_overlay(I)

	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len
		add_overlay(damage_overlays[overlay])

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len
	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

/turf/simulated/wall/proc/update_connections(propagate = 0)
	if(!material)
		return
	var/list/wall_dirs = list()
	var/list/other_dirs = list()

	for(var/turf/simulated/wall/W in orange(src, 1))
		switch(can_join_with(W))
			if(0)
				continue
			if(1)
				wall_dirs += get_dir(src, W)
			if(2)
				wall_dirs += get_dir(src, W)
				other_dirs += get_dir(src, W)
		if(propagate)
			W.update_connections()
			W.update_icon()

	for(var/turf/T in orange(src, 1))
		var/success = 0
		for(var/obj/O in T)
			for(var/b_type in blend_objects)
				if(istype(O, b_type))
					success = 1
				for(var/nb_type in noblend_objects)
					if(istype(O, nb_type))
						success = 0
				if(success)
					break
			if(success)
				break

		if(success)
			wall_dirs += get_dir(src, T)
			if(get_dir(src, T) in GLOB.cardinal)
				other_dirs += get_dir(src, T)

	wall_connections = dirs_to_corner_states(wall_dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && get_wall_state() == W.get_wall_state())
		if((reinf_material && W.reinf_material) || (!reinf_material && !W.reinf_material))
			return 1
		return 2
	for(var/wb_type in blend_turfs)
		if(istype(W, wb_type))
			return 2
	return 0
