/decl/material/proc/get_possible_recipes(var/reinf_mat)
	var/key = reinf_mat || "base"
	if(!LAZYACCESS(recipes,key))
		LAZYSET(recipes,key,generate_recipes(reinf_mat))
	return recipes[key]

/decl/material/proc/get_strut_recipes(var/reinf_mat)
	var/key = reinf_mat || "base"
	. = LAZYACCESS(strut_recipes, key)
	if(!islist(.))
		LAZYSET(strut_recipes, key, generate_strut_recipes(reinf_mat))
		. = LAZYACCESS(strut_recipes, key)

/decl/material/proc/create_recipe_list(base_type)
	. = list()
	for(var/recipe_type in subtypesof(base_type))
		. += new recipe_type(src)

/decl/material/proc/generate_recipes(var/reinforce_material)

	if(phase_at_temperature() != MAT_PHASE_SOLID)
		return list()

	. = list()
	if(opacity < 0.6)
		. += new/datum/stack_crafting/recipe/furniture/borderwindow(src, reinforce_material)
		. += new/datum/stack_crafting/recipe/furniture/fullwindow(src, reinforce_material)
		if(integrity > 75 || reinforce_material)
			. += new/datum/stack_crafting/recipe/furniture/windoor(src, reinforce_material)

	if(reinforce_material)	//recipes below don't support composite materials
		return

	if(hardness >= MAT_VALUE_FLEXIBLE + 10)
		// If is_brittle() returns true, these are only good for a single strike.
		. += new/datum/stack_crafting/recipe/improvised_armour(src)
		. += new/datum/stack_crafting/recipe/armguards(src)
		. += new/datum/stack_crafting/recipe/legguards(src)
		. += new/datum/stack_crafting/recipe/gauntlets(src)

		if(integrity >= 50)
			. += new/datum/stack_crafting/recipe/furniture/door(src)
			. += new/datum/stack_crafting/recipe/furniture/barricade(src)
			. += new/datum/stack_crafting/recipe/furniture/stool(src)
			. += new/datum/stack_crafting/recipe/furniture/bar_stool(src)
			. += new/datum/stack_crafting/recipe/furniture/coatrack(src)
			. += new/datum/stack_crafting/recipe/furniture/bed(src)
			. += new/datum/stack_crafting/recipe/furniture/pew(src)
			. += new/datum/stack_crafting/recipe/furniture/pew_left(src)
			. += new/datum/stack_crafting/recipe/furniture/closet(src)
			. += new/datum/stack_crafting/recipe/furniture/tank_dispenser(src)
			. += new/datum/stack_crafting/recipe/furniture/coffin(src)
			. += new/datum/stack_crafting/recipe/furniture/chair(src) //NOTE: the wood material has it's own special chair recipe
			. += new/datum/stack_crafting/recipe/furniture/chair/padded(src)
			. += new/datum/stack_crafting/recipe/furniture/chair/office/comfy(src)
			. += new/datum/stack_crafting/recipe/furniture/chair/comfy(src)
			. += new/datum/stack_crafting/recipe/furniture/chair/arm(src)
			. += new/datum/stack_crafting/recipe/furniture/chair/roundedchair(src)
			. += new/datum/stack_crafting/recipe/lock(src)
			. += new/datum/stack_crafting/recipe/key(src)
			. += new/datum/stack_crafting/recipe/rod(src)

	if(hardness > MAT_VALUE_RIGID + 10)
		. += new/datum/stack_crafting/recipe/fork(src)
		. += new/datum/stack_crafting/recipe/knife(src)
		. += new/datum/stack_crafting/recipe/bell(src)
		. += new/datum/stack_crafting/recipe/blade(src)
		. += new/datum/stack_crafting/recipe/drill_head(src)
		. += new/datum/stack_crafting/recipe/ashtray(src)
		. += new/datum/stack_crafting/recipe/ring(src)
		. += new/datum/stack_crafting/recipe/clipboard(src)
		. += new/datum/stack_crafting/recipe/cross(src)
		. += new/datum/stack_crafting/recipe/baseball_bat(src)
		. += new/datum/stack_crafting/recipe/urn(src)
		. += new/datum/stack_crafting/recipe/spoon(src)

		var/list/coin_recipes = list()
		var/list/all_currencies = decls_repository.get_decls_of_subtype(/decl/currency)
		for(var/cur in all_currencies)
			var/decl/currency/currency = all_currencies[cur]
			for(var/datum/denomination/denomination in currency.denominations)
				if(length(denomination.faces))
					coin_recipes += new /datum/stack_crafting/recipe/coin(src, null, denomination)
		if(length(coin_recipes))
			. += new/datum/stack_crafting/sublist("antique coins", coin_recipes)

/decl/material/proc/generate_strut_recipes(var/reinforce_material)
	. = list()

	if(wall_support_value >= 10)
		. += new/datum/stack_crafting/recipe/furniture/girder(src)
		. += new/datum/stack_crafting/recipe/furniture/ladder(src)
	. += new/datum/stack_crafting/recipe/railing(src)
	. += new/datum/stack_crafting/recipe/furniture/wall_frame(src)
	. += new/datum/stack_crafting/recipe/furniture/table_frame(src)
	. += new/datum/stack_crafting/recipe/furniture/rack(src)
	. += new/datum/stack_crafting/recipe/butcher_hook(src)
	. += new/datum/stack_crafting/recipe/furniture/bed(src)
	. += new/datum/stack_crafting/recipe/furniture/machine(src)
