/obj/item/chems/cooking_vessel/pot
	name               = "pot"
	desc               = "A large pot for boiling things."
	icon               = 'icons/obj/food/cooking_vessels/pot.dmi'
	volume             = 100
	cooking_category   = RECIPE_CATEGORY_POT
	presentation_flags = PRESENTATION_FLAG_NAME
	obj_flags          = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/cooking_vessel/pot/get_cooking_contents_strings()
	. = ..()
	if(reagents?.total_volume)
		for(var/reagent_type in reagents.reagent_volumes)
			var/decl/material/reagent = GET_DECL(reagent_type)
			var/reagent_name = reagent.get_reagent_name(reagents)
			if(!isnull(reagent.boiling_point) && temperature >= reagent.boiling_point)
				. += "[reagents.reagent_volumes[reagent_type]]u of simmering [reagent_name]"
			else
				. += "[reagents.reagent_volumes[reagent_type]]u of [reagent_name]"

/obj/item/chems/cooking_vessel/pot/on_update_icon()
	. = ..()
	if(reagents?.total_volume)
		for(var/reagent_type in reagents?.reagent_volumes)
			var/decl/material/reagent = GET_DECL(reagent_type)
			if(!isnull(reagent.boiling_point) && temperature >= reagent.boiling_point)
				add_overlay(overlay_image(icon, "[icon_state]-boiling", reagents.get_color(), RESET_COLOR | RESET_ALPHA))
				return
		add_overlay(overlay_image(icon, "[icon_state]-still", reagents.get_color(), RESET_COLOR | RESET_ALPHA))
