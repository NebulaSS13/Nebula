/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials
	name = "MATERIALS: Crafting Recipes Shall Not Have Inconsistent Materials"

/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials/start_test()

	var/list/seen_design_types = list()
	var/list/failed_designs =    list()
	var/list/passed_designs =    list()
	var/failed_count = 0

	var/list/stack_types = list(
		null,
		/obj/item/stack/material/strut,
		/obj/item/stack/material/ore
	)

	for(var/decl/material/mat_datum as anything in SSmaterials.materials)

		var/list/recipes = list()
		for(var/stack_type in stack_types)
			for(var/thing in mat_datum.get_recipes(stack_type))
				if(istype(thing, /datum/stack_recipe))
					recipes += thing
				else if(istype(thing, /datum/stack_recipe_list))
					var/datum/stack_recipe_list/recipe_stack = thing
					if(length(recipe_stack.recipes))
						recipes |= recipe_stack.recipes

		for(var/datum/stack_recipe/recipe as anything in recipes)
			var/obj/product = recipe.spawn_result()
			var/failed
			if(!product)
				failed = "no product returned"
			else if(!istype(product))
				failed = "non-obj product returned ([product.type])"
			else
				LAZYINITLIST(product.matter) // For the purposes of the following tests not runtiming.
				if(!recipe.use_material && !recipe.use_reinf_material)
					if(length(product.matter))
						failed = "unsupplied material types"
				else if(recipe.use_material && (product.matter[recipe.use_material]/SHEET_MATERIAL_AMOUNT) > recipe.req_amount)
					failed = "excessive base material ([recipe.req_amount]/[CEILING(product.matter[recipe.use_material]/SHEET_MATERIAL_AMOUNT)])"
				else if(recipe.use_reinf_material && (product.matter[recipe.use_reinf_material]/SHEET_MATERIAL_AMOUNT) > recipe.req_amount)
					failed = "excessive reinf material ([recipe.req_amount]/[CEILING(product.matter[recipe.use_reinf_material]/SHEET_MATERIAL_AMOUNT)])"
				else
					for(var/mat in product.matter)
						if(mat != recipe.use_material && mat != recipe.use_reinf_material)
							failed = "extra material type ([mat])"
			if(failed) // Try to prune out some duplicate error spam, we have too many materials now
				if(!(recipe.type in seen_design_types))
					failed_designs += "[mat_datum.type] - [recipe.type] - [failed]"
					seen_design_types += recipe.type
				failed_count++
			else
				passed_designs += recipe
			if(!QDELETED(product))
				qdel(product)

	if(failed_count)
		fail("[failed_count] crafting recipes had inconsistent output materials: [jointext(failed_designs, "\n")].")
	else
		pass("[length(passed_designs)] crafting recipes had consistent output materials.")
	return 1
