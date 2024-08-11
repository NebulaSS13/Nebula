/obj/structure
	var/decl/material/material
	var/decl/material/reinf_material
	var/material_alteration
	var/dismantled

/obj/structure/get_material()
	. = material

/obj/structure/proc/get_material_health_modifier()
	. = 1

/obj/structure/proc/update_materials(var/keep_health)
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
	hitsound = material?.hitsound || initial(hitsound)
	if(max_health != -1)
		max_health = initial(max_health) + material?.integrity * get_material_health_modifier()
		if(reinf_material)
			var/bonus_health = reinf_material.integrity * get_material_health_modifier()
			max_health += bonus_health
			if(!keep_health)
				current_health += bonus_health
		current_health = keep_health ? min(current_health, max_health) : max_health
	update_icon()

/obj/structure/proc/update_material_name(var/override_name)
	var/base_name = override_name || initial(name)
	if(istype(material))
		SetName("[material.solid_name] [base_name]")
	else
		SetName(base_name)

/obj/structure/proc/update_material_desc(var/override_desc)
	var/base_desc = override_desc || initial(desc)
	if(istype(material))
		desc = "[base_desc] This one is made of [material.solid_name]."
	else
		desc = base_desc

/obj/structure/proc/update_material_colour()
	color = get_color()
	if(istype(material))
		alpha = clamp((50 + material.opacity * 255), 0, 255)
	else
		alpha = initial(alpha)

///Spawns a single part_type part, returns the result. Allows overriding spawning the actual part and it's constructor args.
/obj/structure/proc/create_dismantled_part(var/turf/T)
	return new parts_type(T, (material && material.type), (reinf_material && reinf_material.type))

/obj/structure/proc/create_dismantled_products(var/turf/T)
	SHOULD_CALL_PARENT(TRUE)
	if(parts_type && !ispath(parts_type, /obj/item/stack))
		for(var/i = 1 to max(parts_amount, 1))
			LAZYADD(., create_dismantled_part(T))
	else
		for(var/mat in matter)
			var/decl/material/M = GET_DECL(mat)
			var/placing
			if(isnull(parts_amount))
				placing = (matter[mat] / SHEET_MATERIAL_AMOUNT) * 0.75
				if(parts_type)
					placing *= atom_info_repository.get_matter_multiplier_for(parts_type, mat, placing)
				placing = floor(placing)
			else
				placing = parts_amount
			if(placing > 0)
				LAZYADD(., M.place_dismantled_product(T, FALSE, placing, parts_type))

/obj/structure/proc/clear_materials()
	matter = null
	material = null
	reinf_material = null

/obj/structure/proc/dismantle_structure(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(!dismantled)
		dismantled = TRUE
		var/list/products = create_dismantled_products(get_turf(src))
		if(paint_color && length(products))
			for(var/obj/product in products)
				if((isitem(product) || istype(product, /obj/structure)) && product.get_material() == material)
					product.set_color(paint_color)
		clear_materials()
		dump_contents()
		if(!QDELETED(src))
			qdel(src)
	. = TRUE
