/datum/chemical_reaction
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
	var/log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.
	var/lore_text
	var/mechanics_text

/datum/chemical_reaction/proc/can_happen(var/datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	var/temperature = holder.my_atom ? holder.my_atom.temperature : T20C
	if(temperature < minimum_temperature || temperature > maximum_temperature)
		return 0

	return 1

/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	if(thermal_product && ATOM_IS_TEMPERATURE_SENSITIVE(holder.my_atom))
		ADJUST_ATOM_TEMPERATURE(holder.my_atom, thermal_product)

// This proc returns a list of all reagents it wants to use; if the holder has several reactions that use the same reagent, it will split the reagent evenly between them
/datum/chemical_reaction/proc/get_used_reagents()
	. = list()
	for(var/reagent in required_reagents)
		. += reagent

/datum/chemical_reaction/proc/get_reaction_flags(var/datum/reagents/holder)
	return 0

/datum/chemical_reaction/proc/process(var/datum/reagents/holder, var/limit)
	var/data = send_data(holder)

	var/reaction_volume = holder.maximum_volume
	for(var/reactant in required_reagents)
		var/A = REAGENT_VOLUME(holder, reactant) / required_reagents[reactant] / limit // How much of this reagent we are allowed to use
		if(reaction_volume > A)
			reaction_volume = A

	var/reaction_flags = get_reaction_flags(holder)

	for(var/reactant in required_reagents)
		holder.remove_reagent(reactant, reaction_volume * required_reagents[reactant], safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_volume
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced, reaction_flags)

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.my_atom
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
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null
