/decl/chemical_reaction
	abstract_type = /decl/chemical_reaction
	var/name = null
	var/result = null
	var/list/required_reagents = list()
	var/list/catalysts = list()
	var/list/inhibitors = list()
	var/result_amount = 0
	var/hidden_from_codex
	var/maximum_temperature = INFINITY
	var/minimum_temperature = 0
	var/thermal_product
	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'
	var/lore_text
	var/mechanics_text
	var/reaction_category = REACTION_TYPE_COMPOUND
	/// Flags used when reaction processing.
	var/chemical_reaction_flags = 0

/decl/chemical_reaction/proc/can_happen(var/datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	var/atom/location = holder.get_reaction_loc(chemical_reaction_flags)
	var/temperature = location?.temperature || T20C
	if(temperature < minimum_temperature || temperature > maximum_temperature)
		return 0

	return 1

/decl/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	var/atom/location = holder.get_reaction_loc(chemical_reaction_flags)
	if(thermal_product && location && ATOM_SHOULD_TEMPERATURE_ENQUEUE(location))
		ADJUST_ATOM_TEMPERATURE(location, location.temperature + (location.get_thermal_mass_coefficient() * thermal_product))

// This proc returns a list of all reagents it wants to use; if the holder has several reactions that use the same reagent, it will split the reagent evenly between them
/decl/chemical_reaction/proc/get_used_reagents()
	. = list()
	for(var/reagent in required_reagents)
		. += reagent

/decl/chemical_reaction/proc/get_alternate_reaction_indicator(var/datum/reagents/holder)
	return 0

/decl/chemical_reaction/proc/process(var/datum/reagents/holder, var/limit)
	var/data = send_data(holder)

	var/reaction_volume = holder.maximum_volume
	for(var/reactant in required_reagents)
		var/A = CHEMS_QUANTIZE(REAGENT_VOLUME(holder, reactant) / required_reagents[reactant] / limit)  // How much of this reagent we are allowed to use
		if(reaction_volume > A)
			reaction_volume = A

	var/alt_reaction_indicator = get_alternate_reaction_indicator(holder)

	for(var/reactant in required_reagents)
		holder.remove_reagent(reactant, reaction_volume * required_reagents[reactant], safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_volume
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced, alt_reaction_indicator)

//called after processing reactions, if they occurred
/decl/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.get_reaction_loc(chemical_reaction_flags)
	if(mix_message && container && !ismob(container))
		var/turf/T = get_turf(container)
		if(istype(T))
			T.visible_message(SPAN_NOTICE("[html_icon(container)] [mix_message]"))
		else
			container.visible_message(SPAN_NOTICE("[html_icon(container)] [mix_message]"))
		if(reaction_sound)
			playsound(T || container, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/decl/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null
