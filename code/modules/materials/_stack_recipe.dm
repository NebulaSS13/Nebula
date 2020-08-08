/*
 * Recipe datum
 */

// Shared object type
/datum/stack_crafting
	var/name
	var/required_tool
	var/list/craftable_stack_types

/datum/stack_crafting/proc/get_display_html(var/mob/user, var/obj/item/stack/stack, var/datum/stack_crafting/sublist/recipes_sublist)
	return

/datum/stack_crafting/recipe
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
	var/apply_material_name = 1 //Whether the recipe will prepend a material name to the name - 'steel clipboard' vs 'clipboard'
	var/set_dir_on_spawn = TRUE
	var/static/list/stack_multipliers = list(5,10,25)

/datum/stack_crafting/recipe/New(decl/material/material, var/reinforce_material)
	. = ..()
	if(!name && result_type)
		name = atom_info_repository.get_name_for(result_type, material?.type)
	if(material)
		use_material = material.type
		difficulty +=  material.construction_difficulty
	if(reinforce_material)
		use_reinf_material = reinforce_material
	SSfabrication.init_crafting_recipe(src)

#define CRAFTING_EXTRA_COST_FACTOR 1.2
/datum/stack_crafting/recipe/proc/InitializeMaterials()
	if(result_type && isnull(req_amount))
		req_amount = 0
		var/list/materials = atom_info_repository.get_matter_for(result_type, use_material, res_amount)
		for(var/mat in materials)
			req_amount += round(materials[mat]/res_amount)
		req_amount = clamp(CEILING(((req_amount*CRAFTING_EXTRA_COST_FACTOR)/SHEET_MATERIAL_AMOUNT) * res_amount), 1, 50)

#undef CRAFTING_EXTRA_COST_FACTOR

/datum/stack_crafting/recipe/proc/display_name()
	if(!use_material || !apply_material_name)
		return name
	var/decl/material/material = GET_DECL(use_material)
	. = "[material.solid_name] [name]"
	if(use_reinf_material)
		material = GET_DECL(use_reinf_material)
		. = "[material.solid_name]-reinforced [.]"

/datum/stack_crafting/recipe/proc/spawn_result(mob/user, location, amount)
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

/datum/stack_crafting/recipe/proc/can_make(mob/user)
	if (one_per_turf && (locate(result_type) in user.loc))
		to_chat(user, "<span class='warning'>There is another [display_name()] here!</span>")
		return FALSE

	var/turf/T = get_turf(user.loc)
	if (on_floor && !T.is_floor())
		to_chat(user, "<span class='warning'>\The [display_name()] must be constructed on the floor!</span>")
		return FALSE

	return TRUE

/datum/stack_crafting/recipe/get_display_html(var/mob/user, var/obj/item/stack/stack, var/datum/stack_crafting/sublist/recipes_sublist)

	if (res_amount > 1)
		. = "[res_amount]x [display_name()]\s"
	else
		. = "[display_name()] ([req_amount] [stack.singular_name]\s)"
	var/max_multiplier = round(stack.get_amount() / req_amount)
	if(max_multiplier > 0)
		if(recipes_sublist)
			. = "<A href='?src=\ref[stack];sublist=["\ref[recipes_sublist]"];make=["\ref[src]"];multiplier=1'>[.]</A>"
		else
			. = "<A href='?src=\ref[stack];make=["\ref[src]"];multiplier=1'>[.]</A>"
	. = "<td>[.]</td>"

	var/decl/hierarchy/skill/S = GET_DECL(SKILL_CONSTRUCTION)
	if(user.skill_check(SKILL_CONSTRUCTION, difficulty))
		. = "[.]<td></td>"
	else
		. = "[.]<td><font color='red'>\[[S.levels[difficulty]]]</font></td>"

	if (max_res_amount > 1 && max_multiplier > 1)
		max_multiplier = min(max_multiplier, round(max_res_amount/res_amount))
		var/list/mults = list()
		for(var/n in stack_multipliers)
			if (max_multiplier >= n)
				mults += " <A href='?src=\ref[stack];make=["\ref[src]"];multiplier=[n]'>[n*res_amount]x</A>"
		. = "[.]<td>[JOINTEXT(mults)]"
		if(!(max_multiplier in stack_multipliers))
			. = "[.] <A href='?src=\ref[stack];make=["\ref[src]"];multiplier=[max_multiplier]'>[max_multiplier*res_amount]x</A>"
		. = "[.]</td>"
	else
		. = "[.]<td></td>"
	. = "<tr>[.]</tr>"

/*
 * Recipe list datum
 */
/datum/stack_crafting/sublist
	var/list/recipes

/datum/stack_crafting/sublist/New(name, recipes)
	..()
	src.name = name
	src.recipes = recipes 

	// Categories will sync to or from the subrecipes when it comes to tool and stack
	// requirements. This is really clunky but currently nothing should be using it.
	for(var/datum/stack_crafting/recipe in recipes)
		if(recipe.required_tool && !required_tool)
			required_tool = recipe.required_tool
		else if(!recipe.required_tool && required_tool)
			recipe.required_tool = required_tool
		if(LAZYLEN(recipe.craftable_stack_types))
			LAZYDISTINCTADD(craftable_stack_types, recipe.craftable_stack_types)

/datum/stack_crafting/sublist/get_display_html(var/mob/user, var/obj/item/stack/stack, var/datum/stack_crafting/sublist/recipes_sublist)
	return "<tr><td><a href='?src=\ref[stack];sublist=["\ref[src]"]'>[name]</a></td><td>Submenu</td></tr>"

