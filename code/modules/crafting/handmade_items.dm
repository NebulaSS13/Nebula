/obj/item/chems/glass/handmade
	abstract_type = /obj/item/chems/glass/handmade
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/stone/pottery
	color = /decl/material/solid/stone/pottery::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	presentation_flags = PRESENTATION_FLAG_NAME

/obj/item/chems/glass/handmade/can_lid()
	return FALSE

/obj/item/chems/glass/handmade/on_reagent_change()
	if((. = ..()))
		update_icon()

/obj/item/chems/glass/handmade/get_mould_difficulty()
	return SKILL_NONE

/obj/item/chems/glass/handmade/teapot
	name = "teapot"
	desc = "A handmade, slightly lumpy teapot."
	icon = 'icons/obj/items/handmade/teapot.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 120
	obj_flags = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/glass/handmade/cup
	name = "cup"
	desc = "A handmade, slightly lumpy cup."
	icon = 'icons/obj/items/handmade/cup.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 30

/obj/item/chems/glass/handmade/mug
	name = "mug"
	desc = "A handmade, slightly lumpy mug."
	icon = 'icons/obj/items/handmade/mug.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 60
	obj_flags = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/glass/handmade/vase
	name = "vase"
	desc = "A handmade, slightly lumpy vase."
	icon = 'icons/obj/items/handmade/vase.dmi'
	amount_per_transfer_from_this = 20
	chem_volume = 240

/obj/item/chems/glass/handmade/jar
	name = "jar"
	desc = "A handmade, slightly lumpy jar."
	icon = 'icons/obj/items/handmade/jar.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 60

/obj/item/chems/glass/handmade/bottle
	name = "bottle"
	desc = "A handmade, slightly lumpy bottle."
	icon = 'icons/obj/items/handmade/bottle.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 120

/obj/item/chems/glass/handmade/bottle/tall
	name = "tall bottle"
	icon = 'icons/obj/items/handmade/bottle_tall.dmi'

/obj/item/chems/glass/handmade/bottle/wide
	name = "wide bottle"
	icon = 'icons/obj/items/handmade/bottle_wide.dmi'

/obj/item/chems/glass/handmade/bowl
	name = "bowl"
	desc = "A handmade, slightly lumpy bowl."
	icon = 'icons/obj/items/handmade/bowl.dmi'
	amount_per_transfer_from_this = 10
	chem_volume = 60

/obj/item/chems/glass/handmade/cup/wood
	material = /decl/material/solid/organic/wood/oak

/obj/item/chems/glass/handmade/mug/wood
	material = /decl/material/solid/organic/wood/oak

/obj/item/chems/glass/handmade/bowl/wood
	material = /decl/material/solid/organic/wood/oak

/obj/item/chems/glass/handmade/bottle/beer/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/alcohol/beer, reagents.maximum_volume)

/obj/item/chems/glass/handmade/bottle/tall/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/alcohol/wine, reagents.maximum_volume)

/obj/item/chems/glass/handmade/bottle/wide/whiskey/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/alcohol/whiskey, reagents.maximum_volume)
