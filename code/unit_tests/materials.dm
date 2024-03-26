/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials
	name = "MATERIALS: Crafting Recipes Shall Not Have Inconsistent Materials"

/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials/start_test()

	var/list/seen_design_types = list()
	var/list/failed_designs =    list()
	var/list/passed_designs =    list()
	var/failed_count = 0

	// Assemble our lists of parameters for recipes.
	var/list/stack_types = list(null)
	var/list/tool_types = list(null)

	var/list/all_recipes = decls_repository.get_decls_of_subtype(/decl/stack_recipe)
	for(var/recipe_type in all_recipes)
		var/decl/stack_recipe/recipe = all_recipes[recipe_type]
		if(recipe.required_tool)
			tool_types |= recipe.required_tool
		if(recipe.craft_stack_types)
			stack_types |= recipe.craft_stack_types

	var/list/all_materials = decls_repository.get_decls_of_type(/decl/material)
	var/list/material_types = list(null)
	for(var/material_type in all_materials)
		var/decl/material/mat = all_materials[material_type]
		if(!mat.holographic && mat.phase_at_temperature() == MAT_PHASE_SOLID)
			material_types |= material_type

	// Force config to be the most precise recipes possible.
	var/decl/config/config = GET_DECL(/decl/config/toggle/on/stack_crafting_uses_types)
	config.set_value(TRUE)
	config = GET_DECL(/decl/config/toggle/stack_crafting_uses_tools)
	config.set_value(TRUE)

	// This is obscene, but completeness requires it.
	for(var/stack_type in stack_types)
		for(var/tool_type in tool_types)
			for(var/material_type in material_types)
				var/decl/material/material = GET_DECL(material_type)
				for(var/reinforced_type in material_types)
					var/decl/material/reinforced = GET_DECL(reinforced_type)

					// Get a linear list of all recipes available to this combination.
					var/list/recipes = get_stack_recipes(material, reinforced, stack_type, tool_type)
					while(locate(/datum/stack_recipe_list) in recipes)
						for(var/datum/stack_recipe_list/recipe_stack in recipes)
							recipes -= recipe_stack
							if(length(recipe_stack.recipes))
								recipes |= recipe_stack.recipes

					if(!length(recipes))
						continue

					// Handle the actual validation.
					for(var/decl/stack_recipe/recipe as anything in recipes)
						if(ispath(recipe.result_type, /turf)) // Cannot exist without a loc and doesn't have matter, cannot assess here.
							continue
						var/atom/product = LAZYACCESS(recipe.spawn_result(null, null, 1, material, reinforced, null), 1)
						var/failed
						if(!product)
							failed = "no product returned"
						else if(!istype(product, recipe.expected_product_type))
							failed = "unexpected product type returned ([product.type])"
						else if(isobj(product))
							var/obj/product_obj = product
							LAZYINITLIST(product_obj.matter) // For the purposes of the following tests not runtiming.
							if(!material && !reinforced)
								if(length(product_obj.matter))
									failed = "unsupplied material types"
							else if(material && (product_obj.matter[material.type]) > recipe.req_amount)
								failed = "excessive base material ([recipe.req_amount]/[CEILING(product_obj.matter[material.type])])"
							else if(reinforced && (product_obj.matter[reinforced.type]) > recipe.req_amount)
								failed = "excessive reinf material ([recipe.req_amount]/[CEILING(product_obj.matter[reinforced.type])])"
							else
								for(var/mat in product_obj.matter)
									if(mat != material?.type && mat != reinforced?.type)
										failed = "extra material type ([mat])"

						if(failed) // Try to prune out some duplicate error spam, we have too many materials now
							if(!(recipe.type in seen_design_types))
								failed_designs += "[material?.type || "null mat"] - [reinforced?.type || "null reinf"] - [tool_type] - [stack_type] - [recipe.type] - [failed]"
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
