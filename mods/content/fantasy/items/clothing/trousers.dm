/obj/item/clothing/pants/trousers
	name                = "trousers"
	desc                = "Some simple trousers. One leg per leg."
	icon                = 'mods/content/fantasy/icons/clothing/trousers.dmi'
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	material            = /decl/material/solid/organic/leather
	sprite_sheets       = list(
		BODYTYPE_HNOLL  = 'mods/content/fantasy/icons/clothing/trousers_hnoll.dmi'
	)

/obj/item/clothing/pants/trousers/jerkin/Initialize()
	. = ..()
	var/obj/item/clothing/shirt/jerkin/jerkin = new
	attach_accessory(null, jerkin)
	if(!(jerkin in accessories))
		qdel(jerkin)

/obj/item/clothing/pants/trousers/braies
	name                = "braies"
	desc                = "Some short trousers. Comfortable and easy to wear."
	icon                = 'mods/content/fantasy/icons/clothing/braies.dmi'
	sprite_sheets       = list(
		BODYTYPE_HNOLL  = 'mods/content/fantasy/icons/clothing/braies_hnoll.dmi'
	)
