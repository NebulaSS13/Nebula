/obj/item/clothing/pants/trousers
	name = "trousers"
	desc = "Some simple trousers. One leg per leg."
	icon = 'mods/species/fantasy/icons/clothing/trousers.dmi'
	sprite_sheets = list(BODYTYPE_HNOLL = 'mods/species/fantasy/icons/clothing/trousers_hnoll.dmi')
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	material = /decl/material/solid/organic/leather

/decl/stack_recipe/textiles/trousers
	result_type       = /obj/item/clothing/pants/trousers
