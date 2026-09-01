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

	var/list/all_recipes = decls_repository.get_decls_of_subtype_unassociated(/decl/stack_recipe)
	for(var/decl/stack_recipe/recipe in all_recipes)
		if(recipe.required_tool)
			tool_types |= recipe.required_tool
		if(recipe.craft_stack_types)
			stack_types |= recipe.craft_stack_types

	// Force config to be the most precise recipes possible.
	// This first one doesn't actually work because it's applied on decl init...
	var/decl/config/config = GET_DECL(/decl/config/toggle/on/stack_crafting_uses_types)
	config.set_value(TRUE)
	config = GET_DECL(/decl/config/toggle/stack_crafting_uses_tools)
	config.set_value(TRUE)

	var/list/test_materials = list(
		GET_DECL(/decl/material/solid/organic/wood/oak),
		GET_DECL(/decl/material/solid/organic/plastic),
		GET_DECL(/decl/material/solid/organic/meat),
		GET_DECL(/decl/material/solid/organic/cloth/linen),
		GET_DECL(/decl/material/solid/organic/leather),
		GET_DECL(/decl/material/solid/organic/plantmatter/grass/dry),
		GET_DECL(/decl/material/solid/organic/paper),
		GET_DECL(/decl/material/solid/metal/steel),
		GET_DECL(/decl/material/solid/metal/plasteel),
		GET_DECL(/decl/material/solid/metal/gold),
		GET_DECL(/decl/material/solid/metal/aluminium),
		GET_DECL(/decl/material/solid/organic/wax),
		GET_DECL(/decl/material/solid/glass),
		GET_DECL(/decl/material/solid/stone/basalt),
		GET_DECL(/decl/material/solid/clay),
	)

	// Add validation materials if not already present
	// (this is especially useful for modpacked recipes/materials, like nullglass)
	for(var/decl/stack_recipe/the_recipe in all_recipes)
		if(ispath(the_recipe.required_material))
			var/decl/material/the_validation_material = the_recipe.required_material
			if(TYPE_IS_ABSTRACT(the_validation_material))
				the_validation_material = decls_repository.get_first_concrete_decl_path_of_type(the_recipe.required_material)
			test_materials |= GET_DECL(the_validation_material)
			continue
		if(the_recipe.validation_material)
			test_materials |= GET_DECL(the_recipe.validation_material)
			continue

	// This is obscene, but completeness requires it.
	for(var/stack_type in stack_types)
		for(var/tool_type in tool_types)
			for(var/decl/material/test_material in test_materials)
				for(var/decl/material/reinforced as anything in (test_materials + null))

					// Get a linear list of all recipes available to this combination.
					var/list/recipes = get_stack_recipes(test_material, reinforced, stack_type, tool_type, flat = TRUE)
					if(!length(recipes))
						continue

					// Handle the actual validation.
					for(var/decl/stack_recipe/recipe as anything in recipes)
						if(!recipe.result_type || ispath(recipe.result_type, /turf)) // Cannot exist without a loc and doesn't have matter, cannot assess here.
							continue
						var/list/results = recipe.spawn_result(null, null, 1, test_material, reinforced, null)
						var/atom/product = LAZYACCESS(results, 1)
						var/list/failed = list()
						if(!product)
							failed += "no product returned"
						else if(!istype(product, recipe.result_type))
							failed += "unexpected product type, got '[product.type]' (expected '[recipe.result_type]')"
						else if(isobj(product))
							var/list/product_matter = list()
							for(var/obj/product_obj in results)
								product_matter = MERGE_ASSOCS_WITH_NUM_VALUES(product_matter, product_obj.get_contained_matter(include_reagents = FALSE))
							if(!test_material && !reinforced)
								if(length(product_matter))
									failed += "unsupplied material types"
							else if(test_material && (product_matter[test_material.type]) > recipe.req_amount)
								failed += "excessive base material ([recipe.req_amount]/[ceil(product_matter[test_material.type])])"
							else if(reinforced && (product_matter[reinforced.type]) > recipe.req_amount)
								failed += "excessive reinf material ([recipe.req_amount]/[ceil(product_matter[reinforced.type])])"
							else
								for(var/mat in product_matter)
									if(mat != test_material?.type && mat != reinforced?.type)
										failed += "extra material type ([mat])"

						if(length(failed)) // Try to prune out some duplicate error spam, we have too many materials now
							if(!(recipe.type in seen_design_types))
								failed_designs += "[test_material?.type || "null mat"] - [reinforced?.type || "null reinf"] - [tool_type] - [stack_type] - [recipe.type] - [english_list(failed)]"
								seen_design_types += recipe.type
								failed_count++
						else
							passed_designs += recipe
						if(!QDELETED(product))
							qdel(product)
						CHECK_TICK
					CHECK_TICK

	if(failed_count)
		fail("[failed_count] crafting recipes had inconsistent output materials: [jointext(failed_designs, "\n")].")
	else
		pass("[length(passed_designs)] crafting recipes had consistent output materials.")
	return 1

/datum/unit_test/curtain_items_shall_have_consistent_matter
	name = "MATERIALS: Curtain Items Shall Have Consistent Matter Lists"

/datum/unit_test/curtain_items_shall_have_consistent_matter/start_test()
	var/list/all_curtain_subtypes = subtypesof(/obj/item/curtain)
	var/list/failed_curtains = list()
	var/list/passed_curtains = list()

	for(var/curtain_type in all_curtain_subtypes)
		var/obj/item/curtain/curtain_subtype = curtain_type
		var/decl/curtain_kind/curtain_kind = GET_DECL(curtain_subtype::curtain_kind_path)
		if(!curtain_kind || TYPE_IS_ABSTRACT(curtain_subtype))
			continue
		var/list/failed = list()
		curtain_subtype = new curtain_type // atom info repository was failing me here
		var/used_matter = curtain_subtype.matter
		var/expected_material = curtain_kind.material_key
		switch(length(used_matter))
			if(0)
				failed += "did not have matter"
			if(1)
				if(!used_matter[expected_material])
					failed += "did not have expected material (had [used_matter[1]], expected [expected_material])"
			else
				failed += "had too many materials ([length(used_matter)], expected 1)"
		if(length(failed))
			failed_curtains += "[curtain_type] - [english_list(failed)]"
		else
			passed_curtains += curtain_type
		QDEL_NULL(curtain_subtype)

	var/failed_count = length(failed_curtains)
	if(failed_count)
		fail("[failed_count] curtain items had inconsistent matter lists: [jointext(failed_curtains, "\n")].")
	else
		pass("[length(passed_curtains)] curtain items had consistent matter lists.")
	return 1