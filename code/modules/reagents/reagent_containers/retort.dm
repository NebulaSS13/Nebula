/obj/item/chems/glass/retort
	name        = "retort"
	base_name   = "retort"
	desc        = "A strangely-shaped vessel for separating chemicals when heated."
	icon        = 'icons/obj/items/retort.dmi'
	icon_state  = ICON_STATE_WORLD
	chem_volume = 120
	material    = /decl/material/solid/glass
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/chems/glass/retort/can_lid()
	return FALSE

/obj/item/chems/glass/retort/copper
	material   = /decl/material/solid/metal/copper

/obj/item/chems/glass/retort/earthenware
	material   = /decl/material/solid/stone/pottery

/obj/item/chems/glass/retort/update_overlays()
	if(reagents?.total_volume && (!material || material.opacity < 1))
		var/datum/gas_mixture/environment = loc?.return_air()
		var/ambient_pressure = environment ? environment.return_pressure() : ONE_ATMOSPHERE
		for(var/decl/material/reagent as anything in reagents.reagent_volumes)
			if(reagent.phase_at_temperature(temperature, ambient_pressure) == MAT_PHASE_GAS)
				add_overlay(overlay_image(icon, "[icon_state]-fill-boil", reagents.get_color(), (RESET_ALPHA|RESET_COLOR)))
				return
		add_overlay(overlay_image(icon, "[icon_state]-fill", reagents.get_color(), (RESET_ALPHA|RESET_COLOR)))
	. = ..()

/obj/item/chems/glass/retort/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/chems/glass/retort/ProcessAtomTemperature()
	. = ..()
	update_icon()
