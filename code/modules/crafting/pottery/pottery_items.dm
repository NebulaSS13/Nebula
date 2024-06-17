/obj/item/chems/glass/pottery
	abstract_type = /obj/item/chems/glass/pottery
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/stone/pottery
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	presentation_flags = PRESENTATION_FLAG_NAME

/obj/item/chems/glass/pottery/teapot
	name = "teapot"
	desc = "A handmade, slightly lumpy teapot."
	icon = 'icons/obj/pottery/teapot.dmi'
	amount_per_transfer_from_this = 10
	volume = 120
	obj_flags = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/glass/pottery/cup
	name = "cup"
	desc = "A handmade, slightly lumpy cup."
	icon = 'icons/obj/pottery/cup.dmi'
	amount_per_transfer_from_this = 10
	volume = 30

/obj/item/chems/glass/pottery/mug
	name = "mug"
	desc = "A handmade, slightly lumpy mug."
	icon = 'icons/obj/pottery/mug.dmi'
	amount_per_transfer_from_this = 10
	volume = 60
	obj_flags = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/glass/pottery/vase
	name = "vase"
	desc = "A handmade, slightly lumpy vase."
	icon = 'icons/obj/pottery/vase.dmi'
	amount_per_transfer_from_this = 20
	volume = 240

/obj/item/chems/glass/pottery/jar
	name = "jar"
	desc = "A handmade, slightly lumpy jar."
	icon = 'icons/obj/pottery/jar.dmi'
	amount_per_transfer_from_this = 10
	volume = 60

/obj/item/chems/glass/pottery/bottle
	name = "bottle"
	desc = "A handmade, slightly lumpy bottle."
	icon = 'icons/obj/pottery/bottle.dmi'
	amount_per_transfer_from_this = 10
	volume = 120

/obj/item/chems/glass/pottery/bottle/tall
	name = "tall bottle"
	icon = 'icons/obj/pottery/bottle_tall.dmi'

/obj/item/chems/glass/pottery/bottle/wide
	name = "wide bottle"
	icon = 'icons/obj/pottery/bottle_wide.dmi'

/obj/item/chems/glass/pottery/bowl
	name = "bowl"
	desc = "A handmade, slightly lumpy bowl."
	icon = 'icons/obj/pottery/bowl.dmi'
	amount_per_transfer_from_this = 10
	volume = 60

/obj/item/chems/glass/pottery/bowl/on_reagent_change()
	if((. = ..()))
		update_icon()

/obj/item/chems/glass/pottery/bowl/on_update_icon()
	. = ..()
	var/image/soup_overlay = get_soup_overlay()
	if(soup_overlay)
		add_overlay(soup_overlay)

/obj/item/chems/glass/pottery/bottle/beer/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/beer, reagents.maximum_volume)

/obj/item/chems/glass/pottery/bottle/tall/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/wine, reagents.maximum_volume)

/obj/item/chems/glass/pottery/bottle/wide/whiskey/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/whiskey, reagents.maximum_volume)
