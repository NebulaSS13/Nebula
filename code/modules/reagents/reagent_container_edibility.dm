/obj/item/chems/get_edible_material_amount(var/mob/eater)
	return ATOM_IS_OPEN_CONTAINER(src) && REAGENT_TOTAL_VOLUME(reagents)

/obj/item/chems/get_food_default_transfer_amount(mob/eater)
	return eater?.get_eaten_transfer_amount(amount_per_transfer_from_this)

/obj/item/chems/get_food_consumption_method(mob/eater)
	return EATING_METHOD_DRINK
