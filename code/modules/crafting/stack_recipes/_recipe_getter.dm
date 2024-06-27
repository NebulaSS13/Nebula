
/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/name
	var/list/recipes = null

/datum/stack_recipe_list/New(_name, list/_recipes)
	name    = _name
	recipes = _recipes

/datum/stack_recipe_list/proc/get_list_display(mob/user, obj/item/stack/stack)
	return "<tr><td width = '150px'>[name]</td><td colspan = 4 width = '550px'><a href='byond://?src=\ref[stack];sublist=\ref[src]'>expand</td></tr>"

/*
 * Recipe retrieval proc.
 */
var/global/list/cached_recipes = list()
/proc/get_stack_recipes(decl/material/mat, decl/material/reinf_mat, stack_type, tool_type, flat = FALSE)

	// No recipes for holograms or fluids.
	if(istype(mat) && (mat.holographic || mat.phase_at_temperature() != MAT_PHASE_SOLID))
		return list()

	#ifndef UNIT_TEST // key creation is SLOW and in unit testing almost every call to this will be a cache fail
	// Check if we've cached this before.
	var/key = jointext(list((mat?.name || "base"), (reinf_mat?.name || "base"), (stack_type || "base"), (tool_type || "base")), "-")
	. = global.cached_recipes[key]
	#endif
	if(!.)

		. = list()

		// Collect our recipes, grouping as appropriate.
		var/list/grouped_recipes = list()
		var/list/all_recipes = decls_repository.get_decls_of_subtype_unassociated(/decl/stack_recipe)
		for(var/decl/stack_recipe/recipe in all_recipes)
			if(global.using_map.map_tech_level < recipe.available_to_map_tech_level)
				continue
			if(recipe.can_be_made_from(stack_type, tool_type, mat, reinf_mat))
				if(recipe.category && !flat)
					LAZYADD(grouped_recipes[recipe.category], recipe)
				else
					. += recipe

		// Turn groups into recipe lists.
		if(length(grouped_recipes))
			for(var/group_name in grouped_recipes)
				. += new /datum/stack_recipe_list(group_name, grouped_recipes[group_name])
		#ifndef UNIT_TEST // associative list insertion is SLOW and in unit testing almost every call to this will be a cache fail
		global.cached_recipes[key] = .
		#endif
