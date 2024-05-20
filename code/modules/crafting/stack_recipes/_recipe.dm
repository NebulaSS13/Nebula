#define MATERIAL_RECIPE_PARAMS req_mat_to_type(mat, required_material), req_mat_to_type(reinf_mat, required_reinforce_material)

#define MATERIAL_FORBIDDEN -1
#define MATERIAL_ALLOWED    0
#define MATERIAL_REQUIRED   1

#define BASE_CRAFTING_TIME (1 SECOND)
// Normalize crafting time to item size.
#define CRAFT_TIME_SIZE(X) ((ITEM_SIZE_NORMAL/X) * (1 SECOND))
// Add half a second per difficulty level.
#define CRAFT_TIME_DIFFICULTY(X) (X * (0.5 SECONDS))

/*
 * Recipe datum
 */
/decl/stack_recipe
	abstract_type = /decl/stack_recipe
	/// Descriptive name, omitting any materials etc. Taken from product if null.
	var/name
	/// Descriptive name for multiple products, uses "[name]s" if null.
	var/name_plural
	/// Used for name grammar, grabbed from product if null.
	var/gender
	// Object path to the desired product.
	var/result_type
	/// Amount of sheets/ingots/etc needed for this recipe. If null, generates from result matter.
	var/req_amount
	/// Amount of stuff that is produced in one batch (e.g. 4 for floor tiles).
	var/res_amount                       = 1
	// Caps the amount that can be produced in one craft action. Set to null for no cap.
	var/max_res_amount
	/// Time it takes for this recipe to be crafted (not including skill and tool modifiers). If null, generates from product w_class and difficulty.
	var/time
	/// If set, only one of this object can be made per turf.
	var/one_per_turf                     = FALSE
	/// If set will be created on the floor instead of in-hand.
	var/on_floor                         = FALSE
	/// Higher difficulty requires higher skill level to make.
	var/difficulty                       = MAT_VALUE_NORMAL_DIY
	/// Whether the recipe will prepend a material name to the title - 'steel clipboard' vs 'clipboard'.
	var/apply_material_name              = TRUE
	/// Sets direction to the crafting user on creation.
	var/set_dir_on_spawn                 = TRUE
	/// Used to validate some checks like matter (since /turf has no matter).
	var/expected_product_type            = /obj
	/// Used for providing a display name.

	/// What stack types can be used to make this recipe?
	var/list/craft_stack_types           = list(
		/obj/item/stack/material/sheet,
		/obj/item/stack/material/ingot,
		/obj/item/stack/material/plank,
		/obj/item/stack/material/bar,
		/obj/item/stack/material/puck
	)
	/// What stack types cannot be used to make this recipe?
	var/list/forbidden_craft_stack_types = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/log,
		/obj/item/stack/material/lump,
		/obj/item/stack/material/slab
	)
	/// If set, will group recipes under a stack recipe list.
	var/category
	/// Modifies the matter values retrieved by req_amount calculation. Should always be more than 1.
	var/crafting_extra_cost_factor       = 1.2
	/// Skill to check for the recipe.
	var/recipe_skill                     = SKILL_CONSTRUCTION

	/// Tool archetype required, if any.
	var/required_tool
	/// Can this recipe use a material? Set to type for a specific material.
	var/required_material                = MATERIAL_REQUIRED
	/// Can this recipe use a reinforced material? Set to type for a specific material.
	var/required_reinforce_material      = MATERIAL_FORBIDDEN

	/// Minimum material wall support value.
	var/required_wall_support_value
	/// Minimum material integrity value.
	var/required_integrity
	/// Minimum material hardness value.
	var/required_hardness
	/// Maximum material opacity value.
	var/required_max_opacity

/decl/stack_recipe/Initialize()
	. = ..()

	// Use initial() instead of atom info repo
	// to avoid grabbing the material name.
	if(result_type)
		var/obj/result = result_type
		if(isnull(name))
			name = initial(result.name)
		if(isnull(time))
			time = max(0.5 SECONDS, round(BASE_CRAFTING_TIME + CRAFT_TIME_SIZE(initial(result.w_class)) + CRAFT_TIME_DIFFICULTY(difficulty), 5))
		if(isnull(gender))
			gender = initial(result.gender)

	// Clamp stack max amount to this regardless of anything else
	// so we don't lose material on crafting an impossible stack.
	if(ispath(result_type, /obj/item/stack))
		var/obj/item/stack/result_stack = result_type
		var/stack_max = initial(result_stack.max_amount)
		if(isnull(max_res_amount) || max_res_amount > stack_max)
			max_res_amount = stack_max

	if(isnull(name_plural))
		name_plural = "[name]s"

	// Wipe our tool requirements if the server is not configured to use them.
	if(required_tool && !get_config_value(/decl/config/toggle/stack_crafting_uses_tools))
		required_tool = null

	// We keep the stack blacklists because they're mainly there to stop people crafting with raw forms.
	if(craft_stack_types && !get_config_value(/decl/config/toggle/on/stack_crafting_uses_types))
		craft_stack_types = null

	update_req_amount()

/decl/stack_recipe/validate()
	. = ..()

	if(isnull(initial(req_amount)) && crafting_extra_cost_factor < 1)
		. += "crafting cost factor is less than one, this may result in free materials."

	if(!istext(name))
		. += "null or non-text name: [name || "NULL"]"
	if(!isnum(time))
		. += "null or non-text crafting time: [time || "NULL"]"
	if(!ispath(result_type))
		. += "null or non-path result type: [result_type || "NULL"]"
	else if(!ispath(expected_product_type))
		. += "null or non-path expected product type: [expected_product_type || "NULL"]"
	else if(!ispath(result_type, expected_product_type))
		. += "result type [result_type || "NULL"] is not subtype of expected product type [expected_product_type || "NULL"]"

	if(isnull(required_material) || required_material == MATERIAL_FORBIDDEN)
		if(!isnull(required_wall_support_value))
			. += "null required material but non-null wall support value"
		if(!isnull(required_integrity))
			. += "null required material but non-null integrity value"
		if(!isnull(required_max_opacity))
			. += "null required material but non-null max opacity value"
		if(!isnull(required_hardness))
			. += "null required material but non-null hardness value"

	if(recipe_skill && difficulty > 0)
		var/decl/hierarchy/skill/used_skill = GET_DECL(recipe_skill)
		if(!istype(used_skill))
			. += "invalid skill decl [recipe_skill]"
		else if(length(used_skill.levels) < difficulty)
			. += "required skill [recipe_skill] is missing skill level [isnull(difficulty) ? "NULL" : json_encode(difficulty)]"

	if(length(forbidden_craft_stack_types) && length(craft_stack_types))
		for(var/stack_type in (forbidden_craft_stack_types|craft_stack_types))
			if((stack_type in craft_stack_types) && (stack_type in forbidden_craft_stack_types))
				. += "[stack_type] is in both forbidden and craftable stack types"

/decl/stack_recipe/proc/get_list_display(mob/user, obj/item/stack/stack)

	. = list("<tr>")

	. += "<td width = '150px'>"
	. += get_display_name(res_amount, apply_article = FALSE)
	. += "</td>"

	. += "<td width = '75px'>"
	. += "[req_amount] [req_amount == 1 ? stack.singular_name : stack.plural_name]"
	. += "</td>"

	. += "<td width = '75px'>"
	. += "[round(time / 10, 0.5)] second\s"
	. += "</td>"

	. += "<td width = '200px'>"
	if(recipe_skill && difficulty)
		var/decl/hierarchy/skill/S = GET_DECL(recipe_skill)
		var/skill_message = "[capitalize(LAZYACCESS(S.levels, difficulty))] [capitalize(S.name)]"
		if(user.skill_check(recipe_skill, difficulty))
			. += skill_message
		else
			. += "<font color='red'>[skill_message]</font>"
	. += "</td>"

	. += "<td width = '200px'>"
	var/max_multiplier = round(stack.get_amount() / req_amount)
	if(max_multiplier)
		if(max_res_amount > 0)
			max_multiplier = min(max_multiplier, round(max_res_amount / res_amount))
		var/static/list/multipliers = list(1, 5, 10, 25, 50)
		for(var/n in multipliers)
			if(max_multiplier < n)
				break
			. += "<a href='?src=\ref[stack];make=\ref[src];multiplier=[n]'>[n*res_amount]x</a>"
		if(!(max_multiplier in multipliers))
			. += "<a href='?src=\ref[stack];make=\ref[src];multiplier=[max_multiplier]'>[max_multiplier*res_amount]x</a>"
	. += "</td>"
	. += "</tr>"

	. = JOINTEXT(.)

/decl/stack_recipe/proc/can_be_made_from(stack_type, tool_type, decl/material/mat, decl/material/reinf_mat)

	// Check if they're using the appropriate materials.
	if(ispath(required_material) && !istype(mat, required_material))
		return FALSE
	else if(required_material == MATERIAL_FORBIDDEN && mat)
		return FALSE
	else if(required_material == MATERIAL_REQUIRED && !mat)
		return FALSE

	if(ispath(required_reinforce_material) && !istype(reinf_mat, required_reinforce_material))
		return FALSE
	else if(required_reinforce_material == MATERIAL_FORBIDDEN && reinf_mat)
		return FALSE
	else if(required_reinforce_material == MATERIAL_REQUIRED && !reinf_mat)
		return FALSE

	// Check if the material has the appropriate properties.
	if(mat)
		if(!isnull(required_wall_support_value) && mat.wall_support_value < required_wall_support_value)
			return FALSE
		if(!isnull(required_integrity) && mat.integrity < required_integrity)
			return FALSE
		if(!isnull(required_hardness) && mat.hardness < required_hardness)
			return FALSE
		if(!isnull(required_max_opacity) && mat.opacity > required_max_opacity)
			return FALSE

	// Check if they're using the right tool.
	if(required_tool)

		// No tool provided.
		if(!ispath(tool_type, /decl/tool_archetype))
			return FALSE

		// Check if it's in our list.
		if(islist(required_tool))
			var/found_tool
			for(var/req_type in required_tool)
				if(ispath(tool_type, req_type))
					found_tool = TRUE
					break
			if(!found_tool)
				return FALSE
		else if(!ispath(tool_type, required_tool))
			return FALSE

	// Check if they're using the required stack type.
	if(!isnull(craft_stack_types))

		// No stack provided.
		if(!ispath(stack_type, /obj/item/stack))
			return FALSE

		// Check if it's in the whitelist.
		if(islist(craft_stack_types))
			var/found_stack
			for(var/req_type in craft_stack_types)
				if(ispath(stack_type, req_type))
					found_stack = TRUE
					break
			if(!found_stack)
				return FALSE
		else if(!ispath(stack_type, craft_stack_types))
			return FALSE

	// Check if the stack type is forbidden for this recipe.
	if(stack_type && !isnull(forbidden_craft_stack_types))
		if(islist(forbidden_craft_stack_types))
			for(var/bad_type in forbidden_craft_stack_types)
				if(ispath(stack_type, bad_type))
					return FALSE
		else if(ispath(stack_type, forbidden_craft_stack_types))
			return FALSE

	// All good!
	return TRUE

/decl/stack_recipe/proc/update_req_amount()
	if(result_type && isnull(req_amount))
		req_amount = 0
		var/list/materials
		materials = atom_info_repository.get_matter_for(result_type, (ispath(required_material) ? required_material : null), res_amount)
		for(var/mat in materials)
			req_amount += round(materials[mat]/res_amount)
		req_amount = clamp(CEILING(((req_amount*crafting_extra_cost_factor)/SHEET_MATERIAL_AMOUNT) * res_amount), 1, 50)

/decl/stack_recipe/proc/get_display_name(amount, decl/material/mat, decl/material/reinf_mat, apply_article = TRUE)
	var/material_strings
	if(apply_material_name)
		if(mat && required_material != MATERIAL_FORBIDDEN)
			LAZYDISTINCTADD(material_strings, mat.use_name)
		if(reinf_mat && required_reinforce_material != MATERIAL_FORBIDDEN)
			LAZYDISTINCTADD(material_strings, reinf_mat.use_name)
		if(LAZYLEN(material_strings))
			material_strings = "[english_list(material_strings)]"
	if(amount > 1)
		. = jointext(list("[amount]x", material_strings, name_plural), " ")
	else
		. = jointext(list(material_strings, name), " ")
		if(apply_article)
			if(gender == PLURAL)
				. = "some [.]"
			else
				. = ADD_ARTICLE(.)

/decl/stack_recipe/proc/req_mat_to_type(decl/material/mat, mat_req)
	if(mat_req != MATERIAL_FORBIDDEN)
		if(istype(mat))
			return mat.type
		if(ispath(mat, /decl/material))
			return mat
	return null

/decl/stack_recipe/proc/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/atom/O

	//TODO: standardize material argument passing in Initialize().
	if(ispath(result_type, /obj/item/stack)) // Amount is set manually in some overrides as well.
		O = new result_type(location, amount, MATERIAL_RECIPE_PARAMS)
	else
		O = new result_type(location, MATERIAL_RECIPE_PARAMS)

	if(user && set_dir_on_spawn)
		O.set_dir(user?.dir)

	// Temp block pending material/matter rework
	if(mat && mat?.type != DEFAULT_FURNITURE_MATERIAL && istype(O, /obj))
		var/obj/struct = O
		if(LAZYACCESS(struct.matter, DEFAULT_FURNITURE_MATERIAL) > 0)
			struct.matter[mat.type] = max(struct.matter[mat.type], struct.matter[DEFAULT_FURNITURE_MATERIAL])
			struct.matter -= DEFAULT_FURNITURE_MATERIAL
	// End temp block

	if(user && istype(O, /obj/item/stack))
		var/obj/item/stack/S = O
		S.add_to_stacks(user, 1)

	if(!QDELETED(O))
		return O

/decl/stack_recipe/proc/can_make(mob/user)
	if (one_per_turf && (locate(result_type) in user.loc))
		to_chat(user, SPAN_WARNING("There is already [get_display_name(1)] here!"))
		return FALSE
	var/turf/T = get_turf(user.loc)
	if (on_floor && (!istype(T) || !T.is_floor()))
		to_chat(user, SPAN_WARNING("[capitalize(get_display_name(1))] must be constructed on the floor!"))
		return FALSE
	return TRUE
