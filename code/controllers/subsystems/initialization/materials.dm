SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = SS_INIT_MATERIALS
	flags = SS_NO_FIRE

	var/list/materials
	var/list/materials_by_name
	var/list/alloy_components
	var/list/alloy_products
	var/list/processable_ores
	var/list/fusion_reactions

	var/list/all_gasses
	var/list/gas_flag_cache

/datum/controller/subsystem/materials/Initialize()
	build_material_lists()       // Build core material lists.
	build_fusion_reaction_list() // Build fusion reaction tree.
	build_gas_lists()             // Cache our gas data.
	. = ..()

/datum/controller/subsystem/materials/proc/build_gas_lists()
	all_gasses = list()
	gas_flag_cache = list()
	for(var/thing in materials_by_name)
		var/material/mat = materials_by_name[thing]
		if(mat.is_a_gas())
			all_gasses[thing] = mat
			gas_flag_cache[thing] = mat.gas_flags

/datum/controller/subsystem/materials/proc/get_gas_flags(var/id)
	. = gas_flag_cache[id]

/datum/controller/subsystem/materials/proc/build_material_lists()

	if(LAZYLEN(materials))
		return

	materials =         list()
	materials_by_name = list()
	alloy_components =  list()
	alloy_products =    list()
	processable_ores =  list()

	for(var/mtype in subtypesof(/material))
		var/material/new_mineral = mtype
		if(!initial(new_mineral.display_name))
			continue
		new_mineral = new mtype
		materials += new_mineral
		materials_by_name[mtype] = new_mineral
		if(new_mineral.ore_smelts_to || new_mineral.ore_compresses_to)
			processable_ores[mtype] = TRUE
		if(new_mineral.alloy_product && LAZYLEN(new_mineral.alloy_materials))
			alloy_products[new_mineral] = TRUE
			for(var/component in new_mineral.alloy_materials)
				processable_ores[component] = TRUE
				alloy_components[component] = TRUE

/datum/controller/subsystem/materials/proc/get_material_datum(var/mat)
	. = materials_by_name[mat]
	if(!.)
		if(ispath(mat))
			crash_with("Unable to acquire material by path '[mat]'.")
		else
			crash_with("Unable to acquire material by non-path key '[mat]'.")

/proc/material_display_name(var/mat)
	var/material/material = SSmaterials.get_material_datum(mat)
	if(material)
		return material.display_name
	return null

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
