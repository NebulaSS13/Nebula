#define MATERIAL_FORBIDDEN -1
#define MATERIAL_ALLOWED    0
#define MATERIAL_REQUIRED   1

/*
 * Recipe datum
 */
/decl/stack_recipe

	var/name
	var/result_type
	/// amount of sheets/ingots/etc needed for this recipe
	var/req_amount
	/// amount of stuff that is produced in one batch (e.g. 4 for floor tiles)
	var/res_amount                      = 1
	var/max_res_amount                  = 1
	var/time                            = 0
	var/one_per_turf                    = FALSE
	var/on_floor                        = FALSE
	// higher difficulty requires higher skill level to make.
	var/difficulty                      = MAT_VALUE_NORMAL_DIY
	//Whether the recipe will prepend a material name to the title - 'steel clipboard' vs 'clipboard'
	var/apply_material_name             = TRUE
	var/set_dir_on_spawn                = TRUE
	var/expected_product_type           = /obj

	var/list/craft_stack_types
	var/list/forbidden_craft_stack_type = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/log
	)

	var/category
	var/crafting_extra_cost_factor      = 1.2
	var/recipe_skill                    = SKILL_CONSTRUCTION

	var/required_tool
	var/required_reinforce_material     = MATERIAL_FORBIDDEN
	var/required_material               = MATERIAL_ALLOWED

	var/required_wall_support_value
	var/required_integrity
	var/required_hardness
	var/required_max_opacity

/decl/stack_recipe/validate()
	. = ..()
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

/decl/stack_recipe/proc/get_list_display(mob/user, obj/item/stack/stack)

	. = list("<tr>")

	. += "<td width = '250px'>"
	if (res_amount > 1)
		. += "[res_amount]x [display_name()]\s"
	else
		. += display_name()
	. += " ([req_amount] [stack.singular_name]\s)"
	. += "</td>"

	. += "<td width = '175px'>"
	if(recipe_skill && !user.skill_check(recipe_skill, difficulty))
		var/decl/hierarchy/skill/S = GET_DECL(recipe_skill)
		. += "<font color='red'>(requires [LAZYACCESS(S.levels, difficulty) || "Basic"] [S.name])</font>"
	. += "</td>"

	. += "<td width = '175x'>"
	var/max_multiplier = round(stack.get_amount() / req_amount)
	if(max_multiplier)
		max_multiplier = min(max_multiplier, round(max_res_amount / res_amount))
		var/static/list/multipliers = list(1, 5, 10, 25)
		for(var/n in multipliers)
			if(max_multiplier < n)
				break
			. += "<a href='?src=\ref[stack];make=\ref[src];multiplier=[n]'>[n*res_amount]x</a>"
		if(!(max_multiplier in multipliers))
			. += " <a href='?src=\ref[stack];make=\ref[src];multiplier=[max_multiplier]'>[max_multiplier*res_amount]x</a>"
	. += "</td>"
	. += "</tr>"

	. = JOINTEXT(.)

/decl/stack_recipe/proc/can_be_made_from(stack_type, tool_type, decl/material/mat, decl/material/reinf_mat)

	// Check if they're using the appropriate materials.
	if(ispath(required_material) && !istype(mat, required_material))
		return FALSE
	else if(required_material == required_material && mat)
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
	if(length(craft_stack_types))

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
	if(stack_type && length(forbidden_craft_stack_type))
		if(islist(forbidden_craft_stack_type))
			for(var/bad_type in forbidden_craft_stack_type)
				if(ispath(stack_type, bad_type))
					return FALSE
		else if(ispath(stack_type, forbidden_craft_stack_type))
			return FALSE

	// All good!
	return TRUE

/decl/stack_recipe/Initialize()
	. = ..()

	// Wipe our tool requirements if the server is not configured to use them.
	if(required_tool && !get_config_value(/decl/config/toggle/stack_crafting_uses_tools))
		required_tool = null

	// We keep the stack blacklists because they're mainly there to stop people crafting with raw forms.
	if(craft_stack_types && !get_config_value(/decl/config/toggle/on/stack_crafting_uses_types))
		craft_stack_types = null

	update_req_amount()

/decl/stack_recipe/proc/update_req_amount()
	if(result_type && isnull(req_amount))
		req_amount = 0
		var/list/materials = atom_info_repository.get_matter_for(result_type, ispath(required_material) ? required_material : null, res_amount)
		for(var/mat in materials)
			req_amount += round(materials[mat]/res_amount)
		req_amount = clamp(CEILING(((req_amount*crafting_extra_cost_factor)/SHEET_MATERIAL_AMOUNT) * res_amount), 1, 50)

/decl/stack_recipe/proc/display_name(decl/material/mat, decl/material/reinf_mat)
	if(!apply_material_name)
		return name
	var/list/material_strings = list()
	if(mat && required_material != MATERIAL_FORBIDDEN)
		material_strings += mat.use_name
	if(reinf_mat && required_reinforce_material != MATERIAL_FORBIDDEN)
		material_strings += reinf_mat.use_name
	if(length(material_strings))
		return "[english_list(material_strings)] [name]"
	return name

/decl/stack_recipe/proc/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/atom/O

	//TODO: standardize material argument passing in Initialize().
	if(ispath(result_type, /obj/item/stack)) // Amount is set manually in some overrides as well.
		O = new result_type(location, amount, (required_material != MATERIAL_FORBIDDEN ? mat.type : null), (required_reinforce_material != MATERIAL_FORBIDDEN ? reinf_mat.type : null))
	else
		O = new result_type(location, (required_material != MATERIAL_FORBIDDEN ? mat.type : null), (required_reinforce_material != MATERIAL_FORBIDDEN ? reinf_mat.type : null))

	if(user && set_dir_on_spawn)
		O.set_dir(user?.dir)

	// Temp block pending material/matter rework
	if(mat?.type != DEFAULT_FURNITURE_MATERIAL && istype(O, /obj))
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
		to_chat(user, SPAN_WARNING("There is another [display_name()] here!"))
		return FALSE
	var/turf/T = get_turf(user.loc)
	if (on_floor && (!istype(T) || !T.is_floor()))
		to_chat(user, SPAN_WARNING("\The [display_name()] must be constructed on the floor!"))
		return FALSE
	return TRUE
