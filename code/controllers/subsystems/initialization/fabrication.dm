SUBSYSTEM_DEF(fabrication)
	name = "Fabrication"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE

	var/list/recipes =    list()
	var/list/categories = list()
	var/list/crafting_procedures_by_type = list()

	// These should be removed after rewriting research networks and crafting to respect init order.
	var/list/crafting_recipes_to_init = list()
	var/list/rnd_to_init = list()
	var/post_recipe_init = FALSE

/datum/controller/subsystem/fabrication/Initialize()

	// Fab recipes.
	for(var/R in subtypesof(/datum/fabricator_recipe))
		var/datum/fabricator_recipe/recipe = new R
		for(var/fab_type in recipe.fabricator_types)
			LAZYADD(recipes[fab_type], recipe)
			LAZYDISTINCTADD(categories[fab_type], recipe.category)

	// Slapcrafting trees.
	var/list/all_crafting_handlers = decls_repository.get_decls_of_subtype(/decl/crafting_stage)
	for(var/hid in all_crafting_handlers)
		var/decl/crafting_stage/handler = all_crafting_handlers[hid]
		if(ispath(handler.begins_with_object_type))
			LAZYDISTINCTADD(crafting_procedures_by_type[handler.begins_with_object_type], handler)

	for(var/datum/stack_recipe/recipe in crafting_recipes_to_init)
		recipe.InitializeMaterials()
	crafting_recipes_to_init.Cut()

	// R&D designs.
	for(var/datum/design/design in rnd_to_init)
		design.AssembleDesignMaterials()
	rnd_to_init.Cut()
	post_recipe_init = TRUE

	init_rpd_lists()
	. = ..()

/datum/controller/subsystem/fabrication/proc/init_crafting_recipe(var/datum/stack_recipe/recipe)
	if(post_recipe_init)
		recipe.InitializeMaterials()
	else
		crafting_recipes_to_init |= recipe

/datum/controller/subsystem/fabrication/proc/get_categories(var/fab_type)
	. = categories[fab_type]

/datum/controller/subsystem/fabrication/proc/init_rnd_design(var/datum/design/design)
	if(post_recipe_init)
		design.AssembleDesignMaterials()
	else
		rnd_to_init |= design

/datum/controller/subsystem/fabrication/proc/get_recipes(var/fab_type)
	. = recipes[fab_type]

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
