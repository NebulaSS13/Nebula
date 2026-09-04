/decl/recipe/steamed
	abstract_type = /decl/recipe/steamed
	// some arbitrary value to make sure it doesn't cook in open air, but will when microwaved
	// todo: rework futurecooking so that microwaves aren't the only appliance for everything (modern stove, oven, fryer, etc)
	minimum_temperature = 80 CELSIUS

/decl/recipe/steamed/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/soysauce = 5)
	items = list(
		/obj/item/food/egg = 2
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/food/chawanmushi
