/obj/structure
	var/material/material
	var/material/reinf_material
	var/material_alteration
	var/dismantled

/obj/structure/get_material()
	. = material

/obj/structure/proc/update_materials(var/keep_health)
	if(material)
		LAZYSET(matter, material.type, max(matter[material.type], ceil(w_class * INITIAL_MATTER_W_CLASS_MULT * SHEET_MATERIAL_AMOUNT)))
	if(reinf_material)
		LAZYSET(matter, reinf_material.type, max(matter[reinf_material.type], ceil(w_class * 0.25 * SHEET_MATERIAL_AMOUNT)))
	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		update_material_name()
	if(material_alteration & MAT_FLAG_ALTERATION_DESC)
		update_material_desc()
	queue_icon_update()

/obj/structure/proc/update_material_name(var/override_name)
	var/base_name = override_name || initial(name)
	if(istype(material))
		SetName("[material.display_name] [base_name]")
	else
		SetName(base_name)

/obj/structure/proc/update_material_desc(var/override_desc)
	var/base_desc = override_desc || initial(desc)
	if(istype(material))
		desc = "[base_desc] This one is made of [material.display_name]."
	else
		desc = base_desc

/obj/structure/proc/update_material_colour(var/override_colour)
	var/base_colour = override_colour || initial(color)
	if(istype(material))
		color = material.icon_colour
	else
		color = base_colour

/obj/structure/proc/create_dismantled_products(var/turf/T)
	if(parts_type)
		new parts_type(T, (material && material.type), (reinf_material && reinf_material.type))
		return
	for(var/mat in matter)
		var/sheets = Floor(matter[mat]/SHEET_MATERIAL_AMOUNT)
		if(sheets)
			var/material/mat_datum = SSmaterials.get_material_datum(mat)
			mat_datum.place_dismantled_product(T, sheet_amount = sheets)

/obj/structure/proc/dismantle()
	if(!dismantled)
		dismantled = TRUE
		create_dismantled_products(get_turf(src))
		if(!QDELETED(src))
			qdel(src)
	. = TRUE
