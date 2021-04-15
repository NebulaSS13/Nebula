/obj/structure
	var/material_alteration
	var/dismantled

/obj/structure/proc/get_material_health_modifier()
	. = 1

/obj/structure/on_material_change()
	. = ..()
	var/decl/material/material = get_primary_material()
	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		update_material_name()
	if(material_alteration & MAT_FLAG_ALTERATION_DESC)
		update_material_desc()
	if(material && material?.opacity < 0.5)
		set_opacity(FALSE)
	else
		set_opacity(initial(opacity))
	hitsound = material?.hitsound || initial(hitsound)
	if(maxhealth != -1)
		maxhealth = initial(maxhealth) + material?.integrity*get_material_health_modifier()
		var/decl/material/reinf_material = get_reinforcing_material()
		if(reinf_material)
			var/bonus_health = reinf_material.integrity * get_material_health_modifier()
			maxhealth += bonus_health
			health += bonus_health
		health = maxhealth

	queue_icon_update()

/obj/structure/proc/update_material_name(var/override_name)
	var/base_name = override_name || initial(name)
	var/decl/material/material = get_primary_material()
	if(material)
		SetName("[material.solid_name] [base_name]")
	else
		SetName(base_name)

/obj/structure/proc/update_material_desc(var/override_desc)
	var/base_desc = override_desc || initial(desc)
	var/decl/material/material = get_primary_material()
	if(material)
		desc = "[base_desc] This one is made of [material.solid_name]."
	else
		desc = base_desc

/obj/structure/proc/update_material_colour(var/override_colour)
	var/base_colour = override_colour || initial(color)
	var/decl/material/material = get_primary_material()
	if(material)
		color = material.color
	else
		color = base_colour

/obj/structure/proc/create_dismantled_products(var/turf/T)
	if(parts_type)
		new parts_type(T, get_primary_material_type(), get_reinforcing_material_type())
	else 
		var/decl/material/material = get_primary_material()
		if(material)
			material.place_dismantled_product(T)
		var/decl/material/reinf_material = get_reinforcing_material()
		if(reinf_material)
			reinf_material.place_dismantled_product(T)

/obj/structure/proc/dismantle()
	SHOULD_CALL_PARENT(TRUE)
	if(!dismantled)
		dismantled = TRUE
		create_dismantled_products(get_turf(src))
		if(!QDELETED(src))
			qdel(src)
	. = TRUE
