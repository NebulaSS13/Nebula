/obj/item/clothing/accessory/armband
	name = "red armband"
	desc = "A fancy red armband!"
	icon = 'icons/clothing/accessories/armbands/armband_security.dmi'
	bodytype_equip_flags = null
	accessory_slot = ACCESSORY_SLOT_ARMBAND

/obj/item/clothing/accessory/armband/get_initial_accessory_hide_on_states()
	var/static/list/initial_accessory_hide_on_states = list(
		/decl/clothing_state_modifier/rolled_down,
		/decl/clothing_state_modifier/rolled_sleeves
	)
	return initial_accessory_hide_on_states

/obj/item/clothing/accessory/armband/cargo
	name = "cargo armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is brown."
	icon = 'icons/clothing/accessories/armbands/armband_cargo.dmi'

/obj/item/clothing/accessory/armband/science
	name = "science armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is purple."
	icon = 'icons/clothing/accessories/armbands/armband_science.dmi'

/obj/item/clothing/accessory/armband/engine
	name = "engineering armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is orange with a reflective strip!"
	icon = 'icons/clothing/accessories/armbands/armband_engineering.dmi'

/obj/item/clothing/accessory/armband/hydro
	name = "hydroponics armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is green and blue."
	icon = 'icons/clothing/accessories/armbands/armband_hydroponics.dmi'

/obj/item/clothing/accessory/armband/med
	name = "medical armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white."
	icon = 'icons/clothing/accessories/armbands/armband_medical.dmi'

/obj/item/clothing/accessory/armband/medgreen
	name = "EMT armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white and green."
	icon = 'icons/clothing/accessories/armbands/armband_medical_green.dmi'

/obj/item/clothing/accessory/armband/medblue
	name = "medical corps armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white and blue."
	icon = 'icons/clothing/accessories/armbands/armband_medical_blue.dmi'

/obj/item/clothing/accessory/armband/bluegold
	name = "peacekeeper armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is blue and gold."
	icon = 'icons/clothing/accessories/armbands/armband_sol.dmi'
