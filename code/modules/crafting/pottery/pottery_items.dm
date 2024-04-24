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

/decl/material
	var/soup_overlay
	var/soup_base = "soup_base"

/obj/item/chems/glass/pottery/bowl/on_update_icon()
	. = ..()
	if(reagents?.total_volume > 0)
		var/image/soup_overlay
		var/decl/material/primary_reagent = reagents.get_primary_reagent_decl()
		if(primary_reagent?.soup_base)
			soup_overlay = overlay_image(icon, primary_reagent.soup_base, reagents.get_color(), RESET_COLOR | RESET_ALPHA)
		else
			soup_overlay = overlay_image(icon, "soup_base", reagents.get_color(), RESET_COLOR | RESET_ALPHA)
		for(var/reagent_type in reagents.reagent_volumes)
			var/decl/material/reagent = GET_DECL(reagent_type)
			if(reagent != primary_reagent && reagent.soup_overlay)
				soup_overlay.overlays += overlay_image(icon, reagent.soup_overlay, reagent.color, RESET_COLOR | RESET_ALPHA)
		add_overlay(soup_overlay)
