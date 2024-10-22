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

/decl/recipe/mysterysoup
	display_name = "Mystery Soup"
	items = list(
		/obj/item/chems/glass/bowl,
		/obj/item/food/badrecipe,
		/obj/item/food/tofu,
		/obj/item/food/egg,
		/obj/item/food/dairy/cheese/wedge
	)
	result = /obj/item/chems/glass/bowl/mystery
	reagents = list(
		/decl/material/liquid/water = 10
	)
	container_categories = list(
		RECIPE_CATEGORY_MICROWAVE
	)
	reagent_mix = REAGENT_REPLACE // no raw egg or water
