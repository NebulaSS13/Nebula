/decl/material/proc/get_recipes(var/reinf_mat)
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
		. += new/datum/stack_recipe/furniture/borderwindow(src, reinforce_material)
		. += new/datum/stack_recipe/furniture/fullwindow(src, reinforce_material)
		if(integrity > 75 || reinforce_material)
			. += new/datum/stack_recipe/furniture/windoor(src, reinforce_material)

	if(reinforce_material)	//recipes below don't support composite materials
		return

	if(hardness >= MAT_VALUE_FLEXIBLE + 10)
		// If is_brittle() returns true, these are only good for a single strike.
		. += new/datum/stack_recipe/improvised_armour(src)
		. += new/datum/stack_recipe/armguards(src)
		. += new/datum/stack_recipe/legguards(src)
		. += new/datum/stack_recipe/gauntlets(src)

		if(integrity >= 50)
			. += new/datum/stack_recipe/furniture/door(src)
			. += new/datum/stack_recipe/furniture/barricade(src)
			. += new/datum/stack_recipe/furniture/banner_frame(src)
			. += new/datum/stack_recipe/furniture/stool(src)
			. += new/datum/stack_recipe/furniture/bar_stool(src)
			. += new/datum/stack_recipe/furniture/coatrack(src)
			. += new/datum/stack_recipe/furniture/bed(src)
			. += new/datum/stack_recipe/furniture/pew(src)
			. += new/datum/stack_recipe/furniture/pew_left(src)
			. += new/datum/stack_recipe/furniture/closet(src)
			. += new/datum/stack_recipe/furniture/tank_dispenser(src)
			. += new/datum/stack_recipe/furniture/coffin(src)
			. += new/datum/stack_recipe/furniture/chair(src) //NOTE: the wood material has it's own special chair recipe
			. += new/datum/stack_recipe/furniture/chair/padded(src)
			. += new/datum/stack_recipe/furniture/chair/office/comfy(src)
			. += new/datum/stack_recipe/furniture/chair/comfy(src)
			. += new/datum/stack_recipe/furniture/chair/arm(src)
			. += new/datum/stack_recipe/furniture/chair/roundedchair(src)
			. += new/datum/stack_recipe/lock(src)
			. += new/datum/stack_recipe/key(src)
			. += new/datum/stack_recipe/rod(src)

		. += new/datum/stack_recipe/fork(src)
		. += new/datum/stack_recipe/knife(src)
		. += new/datum/stack_recipe/bell(src)
		. += new/datum/stack_recipe/blade(src)
		. += new/datum/stack_recipe/drill_head(src)
		. += new/datum/stack_recipe/ashtray(src)
		. += new/datum/stack_recipe/ring(src)
		. += new/datum/stack_recipe/clipboard(src)
		. += new/datum/stack_recipe/cross(src)
		. += new/datum/stack_recipe/baseball_bat(src)
		. += new/datum/stack_recipe/urn(src)
		. += new/datum/stack_recipe/spoon(src)

		var/list/coin_recipes = list()
		var/list/all_currencies = decls_repository.get_decls_of_subtype(/decl/currency)
		for(var/cur in all_currencies)
			var/decl/currency/currency = all_currencies[cur]
			for(var/datum/denomination/denomination in currency.denominations)
				if(length(denomination.faces))
					coin_recipes += new /datum/stack_recipe/coin(src, null, denomination)
		if(length(coin_recipes))
			. += new/datum/stack_recipe_list("antique coins", coin_recipes)

/decl/material/proc/generate_strut_recipes(var/reinforce_material)
	. = list()

	if(wall_support_value >= 10)
		. += new/datum/stack_recipe/furniture/girder(src)
		. += new/datum/stack_recipe/furniture/ladder(src)
	. += new/datum/stack_recipe/railing(src)
	. += new/datum/stack_recipe/furniture/wall_frame(src)
	. += new/datum/stack_recipe/furniture/table_frame(src)
	. += new/datum/stack_recipe/furniture/rack(src)
	. += new/datum/stack_recipe/butcher_hook(src)
	. += new/datum/stack_recipe/furniture/bed(src)
	. += new/datum/stack_recipe/furniture/machine(src)
