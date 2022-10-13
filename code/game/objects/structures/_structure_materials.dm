/obj/structure
	var/decl/material/reinf_material
	var/dismantled

///Set the reinforced material for this structure. If keep_health is true, it will not reset the health value, and will instead just add the difference to it.
/obj/structure/proc/set_reinforced_material(var/mat, var/keep_health = FALSE)
	if(ispath(mat))
		reinf_material = GET_DECL(mat)
	else
		reinf_material = mat

	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		update_material_name()
	if(material_alteration & MAT_FLAG_ALTERATION_DESC)
		update_material_desc()
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		update_material_colour()
	if((alpha / 255) < 0.5)
		set_opacity(FALSE)
	else
		set_opacity(initial(opacity))
	
	if(max_health != OBJ_HEALTH_NO_DAMAGE)
		if(reinf_material)
			var/bonus_health = reinf_material.integrity * get_material_health_modifier()
			max_health += bonus_health
			if(!keep_health)
				health += bonus_health
		health = keep_health ? min(health, max_health) : max_health
	update_icon()

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

/obj/structure/create_matter()
	..()
	LAZYINITLIST(matter)
	if(reinf_material)
		matter[reinf_material.type] = max(matter[reinf_material.type], round(MATTER_AMOUNT_REINFORCEMENT * get_matter_amount_modifier()))
	UNSETEMPTY(matter)