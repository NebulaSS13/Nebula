/obj/item/pen/crayon/transfer_eaten_material(mob/eater, amount)
	var/decl/tool_archetype/pen/parch = GET_DECL(TOOL_PEN)
	parch.decrement_uses(eater, src, amount, destroy_on_zero = FALSE) // we'll qdel in food code if we eat the end of the crayon
	if(!isliving(eater))
		return
	var/mob/living/living_eater = eater
	var/datum/reagents/eater_ingested = living_eater.get_ingested_reagents()
	if(!eater_ingested)
		return
	if(pigment_type)
		var/partial_amount = ceil(amount * 0.4)
		eater_ingested.add_reagent(pigment_type, partial_amount)
		eater_ingested.add_reagent(/decl/material/solid/organic/wax, amount - partial_amount)
	else
		eater_ingested.add_reagent(/decl/material/solid/organic/wax, amount)

/obj/item/pen/crayon/get_edible_material_amount(mob/eater)
	return max(0, get_tool_property(TOOL_PEN, TOOL_PROP_USES))

/obj/item/pen/crayon/get_food_default_transfer_amount(mob/eater)
	return eater?.get_eaten_transfer_amount(5)
