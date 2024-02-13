/decl/recipe/popcorn
	reagents = list(/decl/material/solid/sodiumchloride = 5)
	fruit = list("corn" = 1)
	result = /obj/item/chems/food/popcorn

/decl/recipe/donkpocket
	display_name = "cooked meatball donk-pocket"
	items = list(
		/obj/item/chems/food/doughslice,
		/obj/item/chems/food/meatball
	)
	result = /obj/item/chems/food/donkpocket //SPECIAL

/decl/recipe/donkpocket/proc/warm_up(var/obj/item/chems/food/donkpocket/being_cooked)
	being_cooked.heat()

/decl/recipe/donkpocket/produce_result(obj/container)
	. = ..(container)
	for(var/obj/item/chems/food/donkpocket/being_cooked in .)
		warm_up(being_cooked)

/decl/recipe/donkpocket/rawmeatball
	display_name = "raw meatball donk-pocket"
	items = list(
		/obj/item/chems/food/doughslice,
		/obj/item/chems/food/rawmeatball
	)

/decl/recipe/donkpocket/warm
	display_name = "warm donk-pocket"
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/chems/food/donkpocket
	)
	result = /obj/item/chems/food/donkpocket //SPECIAL

/decl/recipe/donkpocket/warm/check_items(obj/container)
	. = ..()
	if(!.)
		return FALSE
	for(var/obj/item/chems/food/donkpocket/being_cooked in container.get_contained_external_atoms())
		if(!being_cooked.warm)
			return TRUE
	return FALSE

/decl/recipe/donkpocket/warm/produce_result(obj/container)
	for(var/obj/item/chems/food/donkpocket/being_cooked in container.get_contained_external_atoms())
		if(!being_cooked.warm)
			warm_up(being_cooked)
			return list(being_cooked)
