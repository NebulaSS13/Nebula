/obj/item/chems/cooking_vessel/pot
	name               = "pot"
	desc               = "A large pot for boiling things."
	icon               = 'icons/obj/food/cooking_vessels/pot.dmi'
	volume             = 100
	cooking_category   = RECIPE_CATEGORY_POT
	presentation_flags = PRESENTATION_FLAG_NAME
	obj_flags          = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE
	var/last_boil_status
	var/last_boil_temp

/obj/item/chems/cooking_vessel/pot/iron
	material = /decl/material/solid/metal/iron
	color = /decl/material/solid/metal/iron::color

/obj/item/chems/cooking_vessel/pot/on_update_icon()
	. = ..()
	if(reagents?.total_volume)
		if(last_boil_status)
			add_overlay(overlay_image(icon, "[icon_state]-boiling", reagents.get_color(), RESET_COLOR | RESET_ALPHA))
		else
			add_overlay(overlay_image(icon, "[icon_state]-still", reagents.get_color(), RESET_COLOR | RESET_ALPHA))

/obj/item/chems/cooking_vessel/pot/ProcessAtomTemperature()
	. = ..()

	// Largely ignore return value so we don't skip this update on the final time we temperature process.
	if(isnull(last_boil_temp) || temperature != last_boil_temp)

		last_boil_temp = temperature
		var/next_boil_status = FALSE
		for(var/reagent_type in reagents?.reagent_volumes)
			var/decl/material/reagent = GET_DECL(reagent_type)
			if(!isnull(reagent.boiling_point) && temperature >= reagent.boiling_point)
				next_boil_status = TRUE
				break

		if(next_boil_status != last_boil_status)
			last_boil_status = next_boil_status
			update_icon()

	if(. == PROCESS_KILL)
		last_boil_temp = null
