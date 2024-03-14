/obj/item/chems/food
	/// What object type the food cooks into.
	var/backyard_grilling_product      = /obj/item/chems/food/badrecipe
	/// How many SSobj ticks it takes for the food to cook.
	var/backyard_grilling_rawness      = 30
	/// The message shown when the food cooks.
	var/backyard_grilling_announcement = "smokes and chars!"
	/// The span class used for the message above. Burned food defaults to SPAN_DANGER.
	var/backyard_grilling_span         = "notice"

/obj/item/chems/food/get_dried_product()
	drop_plate(get_turf(loc))
	if(dried_type == type && !dry)
		dry = TRUE
		name = "dried [name]"
		color = "#aaaaaa"
		return src
	return ..()

/obj/item/chems/food/is_dryable()
	return !dry

/obj/item/chems/food/get_dryness_text(var/obj/rack)
	var/moistness = drying_wetness / initial(drying_wetness)
	if(moistness > 0.65)
		return "fresh"
	if(moistness > 0.35)
		return "somewhat dried"
	if(moistness)
		return "almost dried"
	return "dehydrated"

/obj/item/chems/food/dry_out(var/obj/rack, var/drying_power = 1, var/fire_exposed = FALSE, var/silent = FALSE)
	return fire_exposed ? grill(rack) : ..()

/obj/item/chems/food/proc/grill(var/atom/heat_source)
	if(!backyard_grilling_product || backyard_grilling_rawness <= 0)
		return null
	backyard_grilling_rawness--
	if(backyard_grilling_rawness <= 0)
		var/obj/item/food = new backyard_grilling_product
		food.dropInto(loc)
		if(backyard_grilling_announcement)
			if(istype(food, /obj/item/chems/food/badrecipe))
				food.visible_message(SPAN_DANGER("\The [src] [backyard_grilling_announcement]"))
			else
				food.visible_message("<span class='[backyard_grilling_span]'>\The [src] [backyard_grilling_announcement]</span>")
		qdel(src)
		return food

/obj/item/chems/food/proc/get_backyard_grilling_text(var/obj/rack)
	var/moistness = backyard_grilling_rawness / initial(backyard_grilling_rawness)
	if(moistness > 0.65)
		return "uncooked"
	if(moistness > 0.35)
		return "half-cooked"
	if(moistness)
		return "nearly cooked"
	return "cooked"
