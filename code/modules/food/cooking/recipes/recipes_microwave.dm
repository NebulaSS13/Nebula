/decl/recipe/popcorn
	reagents = list(/decl/material/solid/sodiumchloride = 5)
	fruit = list("corn" = 1)
	result = /obj/item/food/popcorn
	container_categories = list(
		RECIPE_CATEGORY_MICROWAVE,
		RECIPE_CATEGORY_SKILLET
	)

/decl/recipe/donkpocket
	display_name = "warm donk-pocket"
	items = list(
		/obj/item/food/donkpocket
	)
	result = /obj/item/food/donkpocket

/decl/recipe/donkpocket/proc/warm_up(var/obj/item/food/donkpocket/being_cooked)
	being_cooked.heat()

/decl/recipe/donkpocket/produce_result(obj/container)
	. = ..(container)
	for(var/obj/item/food/donkpocket/being_cooked in .)
		warm_up(being_cooked)

/decl/recipe/donkpocket/check_items(obj/container)
	. = ..()
	if(!.)
		return FALSE
	for(var/obj/item/food/donkpocket/being_cooked in container.get_contained_external_atoms())
		if(!being_cooked.warm)
			return TRUE
	return FALSE
