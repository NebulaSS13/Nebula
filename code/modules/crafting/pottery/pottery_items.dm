/obj/item/chems/glass/pottery
	abstract_type = /obj/item/chems/glass/pottery
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/stone/pottery
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/chems/glass/pottery/teapot
	name = "teapot"
	desc = "A handmade, slightly lumpy teapot."
	icon = 'icons/obj/pottery/teapot.dmi'
	amount_per_transfer_from_this = 10
	volume = 120

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

/obj/item/chems/glass/pottery/vase
	name = "vase"
	desc = "A handmade, slightly lumpy vase."
	icon = 'icons/obj/pottery/vase.dmi'
	amount_per_transfer_from_this = 20
	volume = 120

/obj/item/chems/glass/pottery/bowl
	name = "bowl"
	desc = "A handmade, slightly lumpy bowl."
	icon = 'icons/obj/pottery/bowl.dmi'
	amount_per_transfer_from_this = 10
	volume = 60

/obj/item/chems/glass/pottery/bowl/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/chems/glass/pottery/bowl/on_update_icon()
	. = ..()
	var/image/soup_overlay = get_soup_overlay()
	if(soup_overlay)
		add_overlay(soup_overlay)
