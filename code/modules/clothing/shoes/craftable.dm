/obj/item/clothing/shoes/craftable
	name = "shoes"
	desc = "A pair of shoes."
	icon_state = "world"
	on_mob_icon = 'icons/clothing/feet/generic_shoes.dmi'
	material = MAT_LEATHER_GENERIC
	applies_material_colour = TRUE
	applies_material_name = TRUE
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	var/shine

/obj/item/clothing/shoes/craftable/boots
	name = "boots"
	desc = "A pair of tall boots."
	on_mob_icon = 'icons/clothing/feet/tall_boots.dmi'

/obj/item/clothing/shoes/craftable/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	var/image/I = ..()
	if(shine && slot == slot_shoes_str)
		var/mutable_appearance/S = new()
		S.icon = I.icon
		S.icon_state = "shine"
		S.appearance_flags = RESET_COLOR
		S.color = adjust_brightness(I.color, shine)
		I.overlays += S
	return I

/obj/item/clothing/shoes/craftable/set_material(var/new_material)
	..()
	if(istype(material))
		desc = "[initial(desc)]. These are made of [material.display_name]."
		if(material.reflectiveness >= MAT_VALUE_DULL)
			shine = material.reflectiveness