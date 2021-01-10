/decl/material/proc/get_recipes(var/reinf_mat)
	var/key = reinf_mat ? reinf_mat : "base"
	if(!LAZYACCESS(recipes,key))
		LAZYSET(recipes,key,generate_recipes(reinf_mat))
	return recipes[key]

/decl/material/proc/create_recipe_list(base_type)
	. = list()
	for(var/recipe_type in subtypesof(base_type))
		. += new recipe_type(src)

/decl/material/proc/generate_recipes(var/reinforce_material)
	. = list()

	if(opacity < 0.6)
		. += new/datum/stack_recipe/furniture/borderwindow(src, reinforce_material)
		. += new/datum/stack_recipe/furniture/fullwindow(src, reinforce_material)
		if(integrity > 75 || reinforce_material)
			. += new/datum/stack_recipe/furniture/windoor(src, reinforce_material)

	if(reinforce_material)	//recipes below don't support composite materials
		return

	// If is_brittle() returns true, these are only good for a single strike.
	. += new/datum/stack_recipe/ashtray(src)
	. += new/datum/stack_recipe/ring(src)
	. += new/datum/stack_recipe/clipboard(src)
	. += new/datum/stack_recipe/cross(src)
	. += new/datum/stack_recipe/improvised_armour(src)
	. += new/datum/stack_recipe/armguards(src)
	. += new/datum/stack_recipe/legguards(src)
	. += new/datum/stack_recipe/gauntlets(src)

	if(hardness >= MAT_VALUE_FLEXIBLE)
		. += new/datum/stack_recipe/baseball_bat(src)
		. += new/datum/stack_recipe/urn(src)
		. += new/datum/stack_recipe/spoon(src)
		. += new/datum/stack_recipe/coin(src)
		. += new/datum/stack_recipe/furniture/door(src)

	if(wall_support_value >= 10)
		. += new/datum/stack_recipe/furniture/girder(src)
		. += new/datum/stack_recipe/furniture/ladder(src)

	if(integrity >= 50 && hardness >= MAT_VALUE_FLEXIBLE + 10)
		. += new/datum/stack_recipe/furniture/door(src)
		. += new/datum/stack_recipe/furniture/barricade(src)
		. += new/datum/stack_recipe/furniture/stool(src)
		. += new/datum/stack_recipe/furniture/bar_stool(src)
		. += new/datum/stack_recipe/furniture/bed(src)
		. += new/datum/stack_recipe/furniture/pew(src)
		. += new/datum/stack_recipe/furniture/pew_left(src)
		. += new/datum/stack_recipe/furniture/chair(src) //NOTE: the wood material has it's own special chair recipe
		. += new/datum/stack_recipe_list("padded [name] chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/padded))
		. += new/datum/stack_recipe/lock(src)
		. += new/datum/stack_recipe/railing(src)
		. += new/datum/stack_recipe/rod(src)
		. += new/datum/stack_recipe/furniture/wall_frame(src)
		. += new/datum/stack_recipe/furniture/table_frame(src)

	if(hardness > MAT_VALUE_RIGID + 10)
		. += new/datum/stack_recipe/fork(src)
		. += new/datum/stack_recipe/knife(src)
		. += new/datum/stack_recipe/bell(src)
		. += new/datum/stack_recipe/blade(src)
		. += new/datum/stack_recipe/drill_head(src)
