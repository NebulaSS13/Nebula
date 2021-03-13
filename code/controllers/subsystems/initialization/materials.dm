#define DAMAGE_OVERLAY_COUNT 16

SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = SS_INIT_MATERIALS
	priority = SS_PRIORITY_MATERIALS

	// Material vars.
	var/list/materials
	var/list/materials_by_name
	var/list/fusion_reactions
	var/list/weighted_minerals_sparse = list()
	var/list/weighted_minerals_rich = list()

	// Chemistry vars.
	var/list/active_holders =                  list()
	var/list/chemical_reactions =              list()
	var/list/chemical_reactions_by_type =      list()
	var/list/chemical_reactions_by_id =        list()
	var/list/chemical_reactions_by_result =    list()
	var/list/processing_holders =              list()
	var/list/pending_reagent_change =          list()
	var/list/cocktails_by_primary_ingredient = list()

	// Overlay caches
	var/list/wall_damage_overlays

/datum/controller/subsystem/materials/Initialize()


	// Init reaction list.
	//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list[/decl/material/foo] is a list of all reactions relating to Foo
	// Note that entries in the list are NOT duplicated. So if a reaction pertains to
	// more than one chemical it will still only appear in only one of the sublists.

	for(var/path in subtypesof(/datum/chemical_reaction))
		var/datum/chemical_reaction/D = new path()
		chemical_reactions[path] = D
		if(!chemical_reactions_by_result[D.result])
			chemical_reactions_by_result[D.result] = list()
		chemical_reactions_by_result[D.result] += D
		if(D.required_reagents && D.required_reagents.len)
			var/reagent_id = D.required_reagents[1]
			if(!chemical_reactions_by_id[reagent_id])
				chemical_reactions_by_id[reagent_id] = list()
			chemical_reactions_by_id[reagent_id] += D

	var/list/cocktails = decls_repository.get_decls_of_subtype(/decl/cocktail)
	for(var/ctype in cocktails)
		var/decl/cocktail/cocktail = cocktails[ctype]
		for(var/reagent in cocktail.ratios)
			LAZYADD(cocktails_by_primary_ingredient[reagent], cocktail)
	// Sort to avoid supersets/subsets being unreachable.
	for(var/reagent in cocktails_by_primary_ingredient)
		sortTim(cocktails_by_primary_ingredient[reagent], /proc/cmp_cocktail_des)

	// Various other material functions.
	build_material_lists()       // Build core material lists.
	build_fusion_reaction_list() // Build fusion reaction tree.

	var/alpha_inc = 256 / DAMAGE_OVERLAY_COUNT
	for(var/i = 1; i <= DAMAGE_OVERLAY_COUNT; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		LAZYADD(wall_damage_overlays, img)

	. = ..()

/datum/controller/subsystem/materials/proc/build_material_lists()
	if(LAZYLEN(materials))
		return
	materials =         list()
	materials_by_name = list()
	for(var/mtype in subtypesof(/decl/material))
		var/decl/material/new_mineral = mtype
		if(!initial(new_mineral.name))
			continue
		new_mineral = GET_DECL(mtype)
		materials += new_mineral
		materials_by_name[mtype] = new_mineral
		if(new_mineral.sparse_material_weight)
			weighted_minerals_sparse[new_mineral.type] = new_mineral.sparse_material_weight
		if(new_mineral.rich_material_weight)
			weighted_minerals_rich[new_mineral.type] = new_mineral.rich_material_weight

/datum/controller/subsystem/materials/proc/build_fusion_reaction_list()
	fusion_reactions = list()
	for(var/rtype in subtypesof(/decl/fusion_reaction))
		var/decl/fusion_reaction/cur_reaction = new rtype()
		if(!fusion_reactions[cur_reaction.p_react])
			fusion_reactions[cur_reaction.p_react] = list()
		fusion_reactions[cur_reaction.p_react][cur_reaction.s_react] = cur_reaction
		if(!fusion_reactions[cur_reaction.s_react])
			fusion_reactions[cur_reaction.s_react] = list()
		fusion_reactions[cur_reaction.s_react][cur_reaction.p_react] = cur_reaction

/datum/controller/subsystem/materials/proc/get_fusion_reaction(var/p_react, var/s_react, var/m_energy)
	. = fusion_reactions[p_react] && fusion_reactions[p_react][s_react]

/datum/controller/subsystem/materials/stat_entry()
	..("AH:[active_holders.len]")

/datum/controller/subsystem/materials/fire(resumed = FALSE)
	if (!resumed)
		processing_holders = active_holders.Copy()
	while(processing_holders.len)
		var/datum/reagents/holder = processing_holders[processing_holders.len]
		processing_holders.len--
		if (QDELETED(holder))
			active_holders -= holder
			log_debug("SSmaterials: QDELETED holder found in processing list!")
			if(MC_TICK_CHECK)
				return
			continue
		if (!holder.process_reactions())
			active_holders -= holder
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/materials/proc/get_random_chem(var/only_if_unique = FALSE, temperature = T20C)
	var/list/all_random_reagents = decls_repository.get_decls_of_type(/decl/material/liquid/random)
	for(var/rtype in all_random_reagents)
		var/decl/material/liquid/random/random = all_random_reagents[rtype]
		if(only_if_unique && random.initialized)
			continue
		if(random.randomize_data(temperature))
			return random.type

// This is a fairly hacky way of preventing multiple on_reagent_change() calls being fired within the same tick.
/datum/controller/subsystem/materials/proc/queue_reagent_change(var/atom/changing)
	if(!pending_reagent_change[changing])
		pending_reagent_change[changing] = TRUE
		addtimer(CALLBACK(src, .proc/do_reagent_change, changing), 0)

/datum/controller/subsystem/materials/proc/do_reagent_change(var/atom/changing)
	pending_reagent_change -= changing
	if(!QDELETED(changing))
		changing.on_reagent_change()

/datum/controller/subsystem/materials/proc/get_cocktails_by_primary_ingredient(var/primary)
	. = cocktails_by_primary_ingredient[primary]
