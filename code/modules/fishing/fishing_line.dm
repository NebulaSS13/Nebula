/obj/item/fishing_line
	name = "fishing line"
	icon = 'icons/obj/fishing_line.dmi'
	icon_state = ICON_STATE_WORLD
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_DESC
	max_health = 100
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic

/obj/item/fishing_line/Initialize()
	. = ..()
	if(material)
		max_health = max(1, round(initial(max_health) * material.tensile_strength))
		current_health = max_health

/obj/item/fishing_line/Destroy()
	if(istype(loc, /obj/item/fishing_rod))
		var/obj/item/fishing_rod/rod = loc
		if(rod.line == src)
			rod.line = null
	return ..()

/obj/item/fishing_line/high_quality
	name = "high-grade fishing line"
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_DESC
	max_health = 150
	material = /decl/material/solid/fiberglass
