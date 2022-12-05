/obj/structure
	var/decl/material/reinf_material
	var/dismantled

/obj/structure/get_reinf_material()
	return reinf_material

//Set the reinforced material for this structure. If keep_health is true, it will not reset the health value, and will instead just add the difference to it.
/obj/structure/set_reinf_material(new_material, keep_health = FALSE, skip_update_material = TRUE, skip_update_matter = FALSE)
	var/decl/material/old_material = reinf_material
	if(ispath(new_material))
		reinf_material = GET_DECL(new_material)
	else
		reinf_material = new_material

	if(!skip_update_matter)
		var/mat_units = MATTER_AMOUNT_REINFORCEMENT * get_matter_amount_modifier()
		if(istype(old_material))
			subtract_matter(old_material, mat_units) //Remove the matter we added for the previous material if applicable
		add_matter(material, mat_units)

	if(!skip_update_material)
		update_material(keep_health)
	return TRUE

/obj/structure/update_material_name(override_name)
	. = ..(override_name ? override_name : "[reinf_material ? "reinforced " : ""][material? "[material.solid_name] " : ""][name]")

/obj/structure/proc/create_dismantled_products(var/turf/T)
	SHOULD_CALL_PARENT(TRUE)
	if(parts_type && !ispath(parts_type, /obj/item/stack))
		for(var/i = 1 to max(parts_amount, 1))
			new parts_type(T, (material && material.type), (reinf_material && reinf_material.type))
	else
		for(var/mat in matter)
			var/decl/material/M = GET_DECL(mat)
			var/placing
			if(isnull(parts_amount))
				placing = (matter[mat] / SHEET_MATERIAL_AMOUNT) * 0.75
				if(parts_type)
					placing *= atom_info_repository.get_matter_multiplier_for(parts_type, mat, placing)
				placing = FLOOR(placing)
			else
				placing = parts_amount
			if(placing > 0)
				M.place_dismantled_product(T, FALSE, placing, parts_type)
	matter = null
	material = null
	reinf_material = null

/obj/structure/proc/dismantle()
	SHOULD_CALL_PARENT(TRUE)
	if(!dismantled)
		dismantled = TRUE
		create_dismantled_products(get_turf(src))
		dump_contents()
		if(!QDELETED(src))
			qdel(src)
	. = TRUE

/obj/structure/update_material_health(override_max_health, keep_health)
	//#TODO: move to /obj level
	if(maxhealth != -1)
		if(istype(material))
			maxhealth = initial(maxhealth) + material?.integrity * get_material_health_modifier()
			if(reinf_material)
				var/bonus_health = reinf_material.integrity * get_material_health_modifier()
				maxhealth += bonus_health
				if(!keep_health)
					health += bonus_health
		health = keep_health ? min(health, maxhealth) : maxhealth