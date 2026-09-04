/obj/item/clothing/shirt/jerkin
	name = "jerkin"
	desc = "A sturdy jerkin, worn on the upper body."
	icon = 'mods/content/fantasy/icons/clothing/jerkin.dmi'
	_hnoll_onmob_icon = 'mods/content/fantasy/icons/clothing/jerkin_hnoll.dmi'
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	material = /decl/material/solid/organic/leather

/obj/item/clothing/shirt/crafted
	desc = "A simple shirt, worn on the upper body."
	icon = 'mods/content/fantasy/icons/clothing/jerkin.dmi' // TODO state with sleeves
	sprite_sheets = list(BODYTYPE_HNOLL = 'mods/content/fantasy/icons/clothing/jerkin_hnoll.dmi')
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/clothing/shirt/crafted/wool
	material = /decl/material/solid/organic/cloth/wool

/obj/item/clothing/shirt/crafted/linen
	material = /decl/material/solid/organic/cloth/linen
