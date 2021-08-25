/datum/unit_test/material_chemical_composition_shall_equal_one
	name = "MATERIALS: Material Chemical Composition Will Equal Exactly 1"

/datum/unit_test/material_chemical_composition_shall_equal_one/start_test()
	var/list/failed = list()
	var/list/passed = list()
	for(var/mat in SSmaterials.materials_by_name)
		var/decl/material/mat_datum = GET_DECL(mat)
		var/list/checking = list(
			"dissolves" = mat_datum.dissolves_into,
			"heats" = mat_datum.heating_products,
			"chills" = mat_datum.chilling_products
		)
		for(var/field in checking)
			var/list/checking_list = checking[field]
			if(length(checking_list))
				var/total = 0
				for(var/chem in checking_list)
					total += checking_list[chem]
				if(total != 1)
					failed += "[mat_datum.type] - [field] - [total]"
				else
					passed += "[mat_datum.type] - [field]"
	if(length(failed))
		fail("[length(failed)] material lists have total makeup not equal to 1: [jointext(failed, "\n")].")
	else
		pass("[length(passed)] material lists had chemical makeup exactly equal to 1.")
	return 1

/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials
	name = "MATERIALS: Crafting Recipes Shall Not Have Inconsistent Materials"

/datum/unit_test/crafting_recipes_shall_not_have_inconsistent_materials/start_test()

	var/list/seen_design_types = list()
	var/list/failed_designs =    list()
	var/list/passed_designs =    list()
	var/failed_count = 0

	for(var/owner_mat in SSmaterials.materials_by_name)
		var/decl/material/mat_datum = GET_DECL(owner_mat)

		var/list/recipes = list()
		for(var/thing in mat_datum.get_recipes())
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
					failed_designs += "[owner_mat] - [recipe.type] - [failed]"
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

/datum/unit_test/material_wall_icons_shall_have_valid_states
	name = "MATERIALS: Material Wall Icons Shall Have Valid States"
	var/const/fwall_state = "fwall_open"

/datum/unit_test/material_wall_icons_shall_have_valid_states/start_test()
	var/list/failed
	var/list/all_materials = decls_repository.get_decls_of_subtype(/decl/material)
	for(var/mat_type in all_materials)
		var/decl/material/mat = all_materials[mat_type]

		if(mat.icon_base)
			if(!check_state_in_icon(fwall_state, mat.icon_base))
				LAZYADD(failed, "[mat_type] - '[mat.icon_base]' - missing false wall opening animation '[fwall_state]'")

		for(var/i = 0 to 7)
			if(mat.icon_base)
				if(!check_state_in_icon("[i]", mat.icon_base))
					LAZYADD(failed, "[mat_type] - '[mat.icon_base]' - missing directional base icon state '[i]'")
				if(!check_state_in_icon("other[i]", mat.icon_base))
					LAZYADD(failed, "[mat_type] - '[mat.icon_base]' - missing connective base icon state 'other[i]'")

			if(mat.wall_flags & PAINT_PAINTABLE)
				if(!check_state_in_icon("paint[i]", mat.icon_base))
					LAZYADD(failed, "[mat_type] - '[mat.icon_base]' - missing directional paint icon state '[i]'")
			if(mat.wall_flags & PAINT_STRIPABLE)
				if(!check_state_in_icon("stripe[i]", mat.icon_base))
					LAZYADD(failed, "[mat_type] - '[mat.icon_base]' - missing directional stripe icon state '[i]'")
			if(mat.wall_flags & WALL_HAS_EDGES)
				if(!check_state_in_icon("other[i]", mat.icon_base))
					LAZYADD(failed, "[mat_type] - '[mat.icon_base]' - missing directional edge icon state '[i]'")

			if(mat.icon_base_natural)
				if(!check_state_in_icon("[i]", mat.icon_base_natural))
					LAZYADD(failed, "[mat_type] - '[mat.icon_base_natural]' - missing directional natural icon state '[i]'")
				if(!check_state_in_icon("shine[i]", mat.icon_base_natural))
					LAZYADD(failed, "[mat_type] - '[mat.icon_base_natural]' - missing natural shine icon state 'shine[i]'")

		if(mat.icon_reinf)
			if(mat.use_reinf_state)
				if(!check_state_in_icon(mat.use_reinf_state, mat.icon_reinf))
					LAZYADD(failed, "[mat_type] - '[mat.icon_reinf]' - missing reinf icon state '[mat.use_reinf_state]'")
			else
				for(var/i = 0 to 7)
					if(!check_state_in_icon("[i]", mat.icon_reinf))
						LAZYADD(failed, "[mat_type] - '[mat.icon_reinf]' - missing directional reinf icon state '[i]'")

	if(length(failed))
		fail("[length(failed)] material\s had invalid wall icon states: [jointext(failed, "\n")].")
	else
		pass("All materials had valid wall icon states.")
	return 1 

/datum/unit_test/fusion_reactions_shall_have_valid_reactants
	name = "MATERIALS: Fusion Reactions Shall Have Valid Reactants"

/datum/unit_test/fusion_reactions_shall_have_valid_reactants/start_test()

	var/list/failed_types = list()
	var/list/failed = list()

	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/fusion_reaction)
	for(var/reaction_type in all_reactions)
		var/decl/fusion_reaction/reaction = all_reactions[reaction_type]
		if(reaction.p_react && !ispath(reaction.p_react, /decl/material))
			failed_types |= reaction.type
			failed += "[reaction.type] has invalid primary reactant type [reaction.p_react]."
		if(reaction.s_react && !ispath(reaction.s_react, /decl/material))
			failed_types |= reaction.type
			failed += "[reaction.type] has invalid secondary reactant type [reaction.s_react]."
		for(var/product in reaction.products)
			if(!ispath(product, /decl/material))
				failed_types |= reaction.type
				failed += "[reaction.type] has invalid product type [product]."
			else if(reaction.products[product] <= 0)
				failed_types |= reaction.type
				failed += "[reaction.type] has invalid product amount for [product]."

	if(length(failed_types))
		fail("[length(failed_types)] reactions\s had invalid reactants or products: [jointext(failed, "\n")].")
	else
		pass("All reactions had valid reactants and products.")
	return 1 

/datum/unit_test/material_gas_symbols_shall_be_unique
	name = "MATERIALS: Gas Symbols Shall Be Unique"

/datum/unit_test/material_gas_symbols_shall_be_unique/start_test()
	var/list/seen = list()
	var/list/failures = list()
	var/list/all_materials = decls_repository.get_decls_of_type(/decl/material)
	for(var/decl_type in all_materials)
		var/decl/material/mat = all_materials[decl_type]
		if(mat.is_abstract())
			continue
		if(!mat.gas_symbol)
			failures += "[mat.type] - false or null gas_symbol"
		else if(mat.gas_symbol in seen)
			failures += "[mat.type] - duplicate gas_symbol ([mat.gas_symbol])"
		else
			seen += mat.gas_symbol

	if(length(failures))
		fail("[length(failures)] material\s had null or non-unique gas symbols:\n[jointext(failures, "\n")]")
	else
		pass("All materials had unique and non-null gas symbols.")
	return 1

