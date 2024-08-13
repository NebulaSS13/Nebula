/obj/item/chems/glass/retort
	name       = "retort"
	base_name  = "retort"
	desc       = "A strangely-shaped vessel for seperating chemicals when heated."
	icon       = 'icons/obj/items/retort.dmi'
	icon_state = ICON_STATE_WORLD
	volume     = 120
	material   = /decl/material/solid/glass
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/chems/glass/retort/copper
	material   = /decl/material/solid/metal/copper

/obj/item/chems/glass/retort/earthenware
	material   = /decl/material/solid/stone/pottery

/obj/item/chems/glass/retort/on_update_icon()
	. = ..()
	if(reagents?.total_volume && (!material || material.opacity < 1))
		for(var/reagent in reagents.reagent_volumes)
			var/decl/material/mat = GET_DECL(reagent)
			if(!isnull(mat.boiling_point) && temperature >= mat.boiling_point)
				add_overlay(overlay_image(icon, "[icon_state]-fill-boil", reagents.get_color(), (RESET_ALPHA|RESET_COLOR)))
				return
		add_overlay(overlay_image(icon, "[icon_state]-fill", reagents.get_color(), (RESET_ALPHA|RESET_COLOR)))

/obj/item/chems/glass/retort/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/chems/glass/retort/ProcessAtomTemperature()
	. = ..()
	update_icon()
