SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	priority =   SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_MATERIALS

	// Materials lists/holders.
	var/list/materials =                    list()
	var/list/alloy_components =             list()
	var/list/alloy_products =               list()
	var/list/processable_ores =             list()
	var/list/fusion_reactions =             list()
	var/list/all_gasses =                   list()
	var/list/gas_flag_cache =               list()

	// Chemistry lists/holders.
	var/list/active_holders =               list()
	var/list/chemical_reactions =           list()
	var/list/chemical_reactions_by_type =   list()
	var/list/chemical_reactions_by_id =     list()
	var/list/chemical_reactions_by_result = list()
	var/list/processing_holders =           list()
	var/list/pending_reagent_change =       list()

/datum/controller/subsystem/chemistry/stat_entry()
	..("AH:[active_holders.len]")

/datum/controller/subsystem/chemistry/Initialize()

	// Init reaction list.
	// Chemical Reactions - Initialises all /datum/chemical_reaction into a list
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list["phoron"] is a list of all reactions relating to phoron
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

	// Init other material and reaction lists as needed.
	// Build core material lists.
	var/list/all_mat_decls = decls_repository.get_decls_of_subtype(/decl/material)
	for(var/mtype in all_mat_decls)
		var/decl/material/new_mineral = all_mat_decls[mtype]
		if(!new_mineral.name)
			continue
		materials[new_mineral] = TRUE
		if(new_mineral.ore_smelts_to || new_mineral.ore_compresses_to)
			processable_ores[mtype] = TRUE
		if(new_mineral.alloy_product && LAZYLEN(new_mineral.alloy_materials))
			alloy_products[new_mineral] = TRUE
			for(var/component in new_mineral.alloy_materials)
				processable_ores[component] = TRUE
				alloy_components[component] = TRUE
		// Cache our gas data.
		if(new_mineral.gas_flags & XGM_GAS_DEFAULT_GAS)
			all_gasses[new_mineral.type] = new_mineral
			gas_flag_cache[new_mineral.type] = new_mineral.gas_flags

	// Build fusion reaction tree.
	for(var/rtype in subtypesof(/decl/fusion_reaction))
		var/decl/fusion_reaction/cur_reaction = new rtype()
		if(!fusion_reactions[cur_reaction.p_react])
			fusion_reactions[cur_reaction.p_react] = list()
		fusion_reactions[cur_reaction.p_react][cur_reaction.s_react] = cur_reaction
		if(!fusion_reactions[cur_reaction.s_react])
			fusion_reactions[cur_reaction.s_react] = list()
		fusion_reactions[cur_reaction.s_react][cur_reaction.p_react] = cur_reaction

	. = ..()

/datum/controller/subsystem/chemistry/fire(resumed = FALSE)
	if (!resumed)
		processing_holders = active_holders.Copy()

	while(processing_holders.len)
		var/datum/reagents/holder = processing_holders[processing_holders.len]
		processing_holders.len--

		if (QDELETED(holder))
			active_holders -= holder
			log_debug("SSchemistry: QDELETED holder found in processing list!")
			if(MC_TICK_CHECK)
				return
			continue

		if (!holder.process_reactions())
			active_holders -= holder

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/chemistry/proc/get_random_chem(var/only_if_unique = FALSE, temperature = T20C)
	var/list/all_random_reagents = decls_repository.get_decls_of_type(/decl/material/random)
	for(var/rtype in all_random_reagents)
		var/decl/material/random/random = all_random_reagents[rtype]
		if(only_if_unique && random.initialized)
			continue
		if(random.randomize_data(temperature))
			return random.type

// This is a fairly hacky way of preventing multiple on_reagent_change() calls being fired within the same tick.
/datum/controller/subsystem/chemistry/proc/queue_reagent_change(var/atom/changing)
	if(!pending_reagent_change[changing])
		pending_reagent_change[changing] = TRUE
		addtimer(CALLBACK(src, .proc/do_reagent_change, changing), 0)

/datum/controller/subsystem/chemistry/proc/do_reagent_change(var/atom/changing)
	pending_reagent_change -= changing
	if(!QDELETED(changing))
		changing.on_reagent_change()
