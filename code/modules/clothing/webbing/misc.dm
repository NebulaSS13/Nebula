/obj/item/clothing/webbing/webbing_large
	name = "large webbing"
	desc = "A large collection of synthcotton pockets and pouches."
	icon = 'icons/clothing/accessories/storage/webbing_large.dmi'
	storage = /datum/storage/pockets/webbing

/obj/item/clothing/webbing/bandolier
	name = "bandolier"
	desc = "A lightweight synthethic bandolier with straps for holding ammunition or other small objects."
	icon = 'icons/obj/items/bandolier.dmi'
	storage = /datum/storage/pockets/bandolier

/obj/item/clothing/webbing/bandolier/crafted
	desc                = "A lightweight pocketed belt that is slung across the body, useful for storing a variety of small items."
	icon                = 'icons/obj/items/bandolier_crafted.dmi'
	storage             = /datum/storage/pockets/bandolier/crafted
	fallback_slot       = slot_w_uniform_str
	material            = /decl/material/solid/organic/leather
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
