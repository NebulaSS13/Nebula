SUBSYSTEM_DEF(fabrication)
	name = "Fabrication"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE

	var/list/all_recipes =                 list()
	var/list/locked_recipes =              list()
	var/list/initial_recipes =             list()
	var/list/categories =                  list()
	var/list/crafting_procedures_by_type = list()
	var/list/recipes_by_product_type =     list()
	var/list/fields_by_id =                list()

	// Fabricators who want their initial recipies
	var/list/fabricators_to_init =         list()
	// These should be removed after rewriting crafting to respect init order.
	var/list/crafting_recipes_to_init = list()
	var/post_recipe_init = FALSE

/datum/controller/subsystem/fabrication/Initialize()

	// Fab recipes.
	for(var/R in subtypesof(/datum/fabricator_recipe))
		var/datum/fabricator_recipe/recipe = R
		if(!initial(recipe.path))
			continue
		recipe = new recipe
		recipes_by_product_type[recipe.path] = recipe
		for(var/fab_type in recipe.fabricator_types)
			LAZYADD(all_recipes[fab_type], recipe)
			LAZYDISTINCTADD(categories[fab_type], recipe.category)
			if(recipe.required_technology)
				LAZYADD(locked_recipes[fab_type], recipe)
			else
				LAZYADD(initial_recipes[fab_type], recipe)

	// Slapcrafting trees.
	var/list/all_crafting_handlers = decls_repository.get_decls_of_subtype(/decl/crafting_stage)
	for(var/hid in all_crafting_handlers)
		var/decl/crafting_stage/handler = all_crafting_handlers[hid]
		if(ispath(handler.begins_with_object_type))
			LAZYDISTINCTADD(crafting_procedures_by_type[handler.begins_with_object_type], handler)

	for(var/datum/stack_recipe/recipe in crafting_recipes_to_init)
		recipe.InitializeMaterials()
	crafting_recipes_to_init.Cut()

	post_recipe_init = TRUE

	for(var/weakref/ref in fabricators_to_init)
		var/obj/machinery/fabricator/F = ref.resolve()
		if(F)
			init_fabricator(F)
	fabricators_to_init.Cut()

	init_rpd_lists()
	. = ..()

/datum/controller/subsystem/fabrication/proc/init_crafting_recipe(var/datum/stack_recipe/recipe)
	if(post_recipe_init)
		recipe.InitializeMaterials()
	else
		crafting_recipes_to_init |= recipe

/datum/controller/subsystem/fabrication/proc/get_research_field_by_id(var/rnd_id)
	if(!length(fields_by_id))
		var/all_fields = decls_repository.get_decls_of_subtype(/decl/research_field)
		for(var/fid in all_fields)
			var/decl/research_field/field = all_fields[fid]
			fields_by_id[lowertext(field.id)] = field
	return fields_by_id[lowertext(rnd_id)]

/datum/controller/subsystem/fabrication/proc/get_categories(var/fab_type)
	. = categories[fab_type]

/datum/controller/subsystem/fabrication/proc/get_all_recipes(var/fab_type)
	. = all_recipes[fab_type]

/datum/controller/subsystem/fabrication/proc/get_initial_recipes(var/fab_type)
	. = initial_recipes[fab_type]

/datum/controller/subsystem/fabrication/proc/get_unlocked_recipes(var/fab_type, var/list/known_tech)
	. = list()
	if(fab_type)
		for(var/datum/fabricator_recipe/design in locked_recipes[fab_type])
			if(design.check_research_requirements(known_tech))
				. += design
	else
		for(var/ftype in locked_recipes)
			for(var/datum/fabricator_recipe/design in locked_recipes[ftype])
				if(design.check_research_requirements(known_tech))
					. += design

/datum/controller/subsystem/fabrication/proc/find_crafting_recipes(var/_type)
	if(isnull(crafting_procedures_by_type[_type]))
		crafting_procedures_by_type[_type] = FALSE
		for(var/check_type in crafting_procedures_by_type)
			if(ispath(_type, check_type))
				crafting_procedures_by_type[_type] = crafting_procedures_by_type[check_type]
				break
	. = crafting_procedures_by_type[_type]

/datum/controller/subsystem/fabrication/proc/try_craft_with(var/obj/item/target, var/obj/item/thing, var/mob/user)
	for(var/decl/crafting_stage/initial_stage in SSfabrication.find_crafting_recipes(target.type))
		if(initial_stage.can_begin_with(target) && initial_stage.is_appropriate_tool(thing))
			var/obj/item/crafting_holder/H = new /obj/item/crafting_holder(get_turf(target), initial_stage, target, thing, user)
			if(initial_stage.progress_to(thing, user, H))
				return H
			else
				qdel(H)

/datum/controller/subsystem/fabrication/proc/init_fabricator(obj/machinery/fabricator/fab)
	if(post_recipe_init)
		var/list/base_designs = get_initial_recipes(fab.fabricator_class)
		fab.design_cache = islist(base_designs) ? base_designs.Copy() : list() // Don't want to mutate the subsystem cache.
		fab.refresh_design_cache()
	else
		fabricators_to_init |= weakref(fab)
	