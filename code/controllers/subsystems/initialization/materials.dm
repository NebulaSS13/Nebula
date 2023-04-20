#define DAMAGE_OVERLAY_COUNT 16

SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = SS_INIT_MATERIALS
	priority = SS_PRIORITY_MATERIALS

	// Material vars.
	var/list/materials
	var/list/strata
	var/list/fusion_reactions
	var/list/materials_by_name =              list()
	var/list/weighted_minerals_sparse =       list()
	var/list/weighted_minerals_rich =         list()

	// Chemistry vars.
	var/list/active_holders =                  list()
	var/list/chemical_reactions_by_id =        list()
	var/list/chemical_reactions_by_result =    list()
	var/list/processing_holders =              list()
	var/list/cocktails_by_primary_ingredient = list()

	// Overlay caches
	var/list/wall_damage_overlays

/datum/controller/subsystem/materials/Initialize()

	// Init reaction list.
	// Chemical Reactions - Organizes /decl/chemical_reaction subtypes into a list
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list[/decl/material/foo] is a list of all reactions relating to Foo
	// Note that entries in the list are NOT duplicated. So if a reaction pertains to
	// more than one chemical it will still only appear in only one of the sublists.

	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)
	for(var/path in all_reactions)
		var/decl/chemical_reaction/D = all_reactions[path]
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
	materials = sortTim(SSmaterials.materials, /proc/cmp_name_asc)
	materials_by_name = sortTim(SSmaterials.materials_by_name, /proc/cmp_name_or_type_asc, TRUE)

	var/alpha_inc = 256 / DAMAGE_OVERLAY_COUNT
	for(var/i = 1; i <= DAMAGE_OVERLAY_COUNT; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		LAZYADD(wall_damage_overlays, img)

	strata = decls_repository.get_decls_of_subtype(/decl/strata) // for debug VV purposes

	. = ..()

/datum/controller/subsystem/materials/proc/build_material_lists()
	if(LAZYLEN(materials))
		return
	materials =         list()
	materials_by_name = list()
	var/list/material_decls = decls_repository.get_decls_of_subtype(/decl/material)
	for(var/mtype in material_decls)
		var/decl/material/new_mineral = material_decls[mtype]
		materials += new_mineral
		materials_by_name[lowertext(new_mineral.name)] = new_mineral
		if(new_mineral.sparse_material_weight)
			weighted_minerals_sparse[new_mineral.type] = new_mineral.sparse_material_weight
		if(new_mineral.rich_material_weight)
			weighted_minerals_rich[new_mineral.type] = new_mineral.rich_material_weight

/datum/controller/subsystem/materials/proc/build_fusion_reaction_list()
	fusion_reactions = list()
	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/fusion_reaction)
	for(var/rtype in all_reactions)
		var/decl/fusion_reaction/cur_reaction = all_reactions[rtype]
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
		if(only_if_unique && random.data_initialized)
			continue
		if(random.randomize_data(temperature))
			return random.type

/datum/controller/subsystem/materials/proc/get_cocktails_by_primary_ingredient(var/primary)
	. = cocktails_by_primary_ingredient[primary]

/datum/controller/subsystem/materials/proc/get_strata_type(var/turf/exterior/wall/location)
	if(!istype(location))
		return

	//Turf may override level_data strata
	if(ispath(location.strata_override))
		return location.strata_override

	//Then level_data
	var/datum/level_data/LD = SSmapping.levels_by_z[location.z]
	if(!LD._level_setup_completed && !LD._has_warned_uninitialized_strata)
		LD.warn_bad_strata(location) //If we haven't warned yet dump a stack trace and warn that strata was set before init

	if(ispath(LD.strata, /decl/strata))
		return LD.strata
	else if(istype(LD.strata, /decl/strata))
		return LD.strata.type

/datum/controller/subsystem/materials/proc/get_material_by_name(var/mat_name)
	if(mat_name)
		mat_name = lowertext(mat_name)
		return materials_by_name[mat_name]

/datum/controller/subsystem/materials/proc/get_strata_material_type(var/turf/exterior/wall/location)
	if(!istype(location))
		return

	//Turf strata overrides level strata
	if(ispath(location.strata_override, /decl/strata))
		var/decl/strata/S = GET_DECL(location.strata_override)
		if(length(S.base_materials))
			return pick(S.base_materials)

	//Try to grab the material we picked for the level from the level data
	var/datum/level_data/LD = SSmapping.levels_by_z[location.z]
	if(!LD._level_setup_completed && !LD._has_warned_uninitialized_strata)
		LD.warn_bad_strata(location) //If we haven't warned yet dump a stack trace and warn that strata was set before init
	return LD.strata_base_material.type

/datum/controller/subsystem/materials/proc/create_object(var/mat_type, var/atom/target, var/amount = 1, var/object_type, var/reinf_type)
	var/decl/material/mat = GET_DECL(mat_type)
	return mat?.create_object(target, amount, object_type, reinf_type)

///Returns the rock color for a given exterior wall
/datum/controller/subsystem/materials/proc/get_rock_color(var/turf/exterior/wall/location)
	if(!istype(location))
		return
	//#TODO: allow specifying rock color per z-level maybe?

	if(istype(location.owner))
		return location.owner.get_rock_color()