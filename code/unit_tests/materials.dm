/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials
	name = "MATERIALS: Crafting Recipes Shall Not Have Inconsistent Materials"

/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials/start_test()
	var/list/failed_designs = list()
	var/list/passed_designs = list()
	for(var/decl/material/mat_datum in SSchemistry.materials)
		for(var/datum/stack_recipe/recipe in mat_datum.get_recipes())
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
					failed = "excessive base material ([recipe.req_amount]/[ceil(product.matter[recipe.use_material]/SHEET_MATERIAL_AMOUNT)])"
				else if(recipe.use_reinf_material && (product.matter[recipe.use_reinf_material]/SHEET_MATERIAL_AMOUNT) > recipe.req_amount)
					failed = "excessive reinf material ([recipe.req_amount]/[ceil(product.matter[recipe.use_reinf_material]/SHEET_MATERIAL_AMOUNT)])"
				else
					for(var/mat in product.matter)
						if(mat != recipe.use_material && mat != recipe.use_reinf_material)
							failed = "extra material type ([mat])"
			if(failed)
				failed_designs += "[mat_datum.type] - [recipe.type] - [failed]"
			else
				passed_designs += recipe
			if(!QDELETED(product))
				qdel(product)

	if(length(failed_designs))
		fail("[length(failed_designs)] crafting recipes had inconsistent output materials: [jointext(failed_designs, "\n")].")
	else
		pass("[length(passed_designs)] crafting recipes had consistent output materials.")
	return 1 