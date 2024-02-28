#define REINFORCE_FORBIDDEN -1
#define REINFORCE_ALLOWED    0
#define REINFORCE_REQUIRED   1

/*
 * Recipe datum
 */
/decl/stack_recipe

	var/name
	var/result_type
	var/req_amount     // amount of material needed for this recipe
	var/res_amount = 1 // amount of stuff that is produced in one batch (e.g. 4 for floor tiles)
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material
	var/use_reinf_material
	var/difficulty = 1 // higher difficulty requires higher skill level to make.
	var/apply_material_name = 1 //Whether the recipe will prepend a material name to the title - 'steel clipboard' vs 'clipboard'
	var/set_dir_on_spawn = TRUE
	var/expected_product_type = /obj
	var/list/craft_stack_types
	var/list/forbidden_craft_stack_type = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/log
	)

	var/category
	var/crafting_extra_cost_factor = 1.2
	var/recipe_skill = SKILL_CONSTRUCTION

	var/required_tool
	var/required_reinforce_material = REINFORCE_FORBIDDEN
	var/required_material

	var/required_wall_support_value
	var/required_integrity
	var/required_hardness
	var/required_max_opacity

/decl/stack_recipe/validate()
	. = ..()
	if(!required_material)
		if(!isnull(required_wall_support_value))
			. += "null required material but non-null wall support value"
		if(!isnull(required_integrity))
			. += "null required material but non-null integrity value"
		if(!isnull(required_max_opacity))
			. += "null required material but non-null max opacity value"
		if(!isnull(required_hardness))
			. += "null required material but non-null hardness value"

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
	if(required_material && !istype(mat, craft_stack_types))
		return FALSE

	if(required_reinforce_material == REINFORCE_FORBIDDEN && reinf_mat)
		return FALSE
	else if(required_reinforce_material == REINFORCE_REQUIRED && !reinf_mat)
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
		var/list/materials = atom_info_repository.get_matter_for(result_type, use_material, res_amount)
		for(var/mat in materials)
			req_amount += round(materials[mat]/res_amount)
		req_amount = clamp(CEILING(((req_amount*crafting_extra_cost_factor)/SHEET_MATERIAL_AMOUNT) * res_amount), 1, 50)

/decl/stack_recipe/proc/display_name()
	if(!use_material || !apply_material_name)
		return name
	var/decl/material/material = GET_DECL(use_material)
	. = "[material.solid_name] [name]"
	if(use_reinf_material)
		material = GET_DECL(use_reinf_material)
		. = "[material.solid_name]-reinforced [.]"

/decl/stack_recipe/proc/spawn_result(mob/user, location, amount)
	var/atom/O
	if(use_material)
		//TODO: standardize material argument passing in Initialize().
		if(ispath(result_type, /obj/item/stack)) // Amount is set manually in some overrides as well.
			O = new result_type(location, amount, use_material, use_reinf_material)
		else
			O = new result_type(location, use_material, use_reinf_material)
	else
		O = new result_type(location)
	if(user && set_dir_on_spawn)
		O.set_dir(user?.dir)

	// Temp block pending material/matter rework
	if(use_material && use_material != DEFAULT_FURNITURE_MATERIAL && istype(O, /obj))
		var/obj/struct = O
		if(LAZYACCESS(struct.matter, DEFAULT_FURNITURE_MATERIAL) > 0)
			struct.matter[use_material] = max(struct.matter[use_material], struct.matter[DEFAULT_FURNITURE_MATERIAL])
			struct.matter -= DEFAULT_FURNITURE_MATERIAL
	// End temp block

	return O

/decl/stack_recipe/proc/can_make(mob/user)
	if (one_per_turf && (locate(result_type) in user.loc))
		to_chat(user, "<span class='warning'>There is another [display_name()] here!</span>")
		return FALSE

	var/turf/T = get_turf(user.loc)
	if (on_floor && !T.is_floor())
		to_chat(user, "<span class='warning'>\The [display_name()] must be constructed on the floor!</span>")
		return FALSE

	return TRUE
