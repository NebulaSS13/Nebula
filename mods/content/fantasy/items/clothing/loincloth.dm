/obj/item/clothing/pants/loincloth
	name = "loincloth"
	gender = NEUTER
	desc = "A simple garment that is worn around the legs and lower body."
	icon = 'mods/content/fantasy/icons/clothing/loincloth.dmi'
	sprite_sheets = list(BODYTYPE_HNOLL = 'mods/content/fantasy/icons/clothing/loincloth_hnoll.dmi')
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	material = /decl/material/solid/organic/skin/fur

/decl/stack_recipe/textiles/loincloth
	result_type       = /obj/item/clothing/pants/loincloth
