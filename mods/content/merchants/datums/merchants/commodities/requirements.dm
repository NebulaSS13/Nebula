/// Used to impose criteria that the merchant can use to compare against to determine if they want to accept a possible transaction involving a specific commodity instance.
/// This is generally only used for items attempting to be sold to merchants. The most basic form of this is generally 'is this the correct type?', but other requirements can also be used to add more complexity.
/decl/merchant_commodity_requirement
	var/naming_position = 0 //! Determines where this adds onto the demand's name. Negative numbers act as prefixes, while positive ones act as suffixes.


/// Used to convert hand-authored parameters into something potentially better suited or more optimized for future checks.
/// Called once on `/datum/merchant_commodity` init.
/decl/merchant_commodity_requirement/proc/build_parameters(list/parameters)
	return parameters


/**
Generates part of the name for a commodity object. Generally takes the form of a prefix or suffix, depending on `naming_position`.
Called once on `/datum/merchant_commodity` init.
- `list/parameters`: Information supplied for future comparisons. Subtypes expect a specific format for their parameters. May or may not actually be a list, depending on subtype.
- `list/all_requirements`: List containing all of the `/decl/merchant_commodity_requirement`s that a particular demand has, including this one. Used to enable soft dependencies.
*/
/decl/merchant_commodity_requirement/proc/generate_name(list/parameters, list/all_requirements)
	return null


/**
Acts as a condition that will determine whether or not a particular `atom/movable/instance` should pass.
This is usually called when a player is trying to sell an instance to a merchant.
- `list/parameters`: Information which was supplied, and is used to make the comparison. Subtypes expect a specific format for their parameters. May or may not actually be a list, depending on subtype.
- `atom/movable/instance`: An instance to compare against.
*/
/decl/merchant_commodity_requirement/proc/compare_instance(list/parameters, atom/movable/instance)
	return FALSE

/**
Acts as a condition that will determine whether or not a particular `type_path` should pass. This is generally only needed for type-specific requirements.
This is usually called when a player is trying to buy a type from a merchant, or if a merchant needs to check if they buy and sell the same thing.
- `list/parameters`: Information which was supplied, and is used to make the comparison. Subtypes expect a specific format for their parameters. May or may not actually be a list, depending on subtype.
- `type_path`: A path to compare against.
*/
/decl/merchant_commodity_requirement/proc/compare_type(list/parameters, type_path)
	return TRUE // Most requirements are either irrelevant or unanswerable if only given a type path.


/// Contains all forms of type checks.
/// This will generally be the most common requirement used.
/decl/merchant_commodity_requirement/type
	abstract_type = /decl/merchant_commodity_requirement/type
	naming_position = 0
	var/verbose_naming = FALSE //! If TRUE, each types' names are used, otherwise only the first type in the list is used for the name.

/decl/merchant_commodity_requirement/type/generate_name(list/parameters, list/all_requirements)
	var/list/type_paths = islist(parameters) ? parameters.Copy() : list(parameters)
	var/list/atom_names = list()
	var/wanted_material = all_requirements[/decl/merchant_commodity_requirement/material]

	for(var/type_path in type_paths)
		var/atom_name = atom_info_repository.get_name_for(type_path, wanted_material)
		atom_names[atom_name] = TRUE // So duplicates don't get repeated multiple times.
		if(!verbose_naming)
			break

	return english_list(atom_names, and_text = " or ")

/decl/merchant_commodity_requirement/type/compare_instance(list/parameters, atom/movable/instance)
	return is_type_in_typecache(instance, parameters)

/decl/merchant_commodity_requirement/type/compare_type(list/parameters, type_path)
	return parameters[type_path]


/// Essentially allows anything to pass.
/// Useful if you want a merchant that buys almost anything, or if you want to restrict by other criteria besides type.
/// Parameterless.
/decl/merchant_commodity_requirement/type/anything

/decl/merchant_commodity_requirement/type/anything/generate_name(list/parameters, list/all_requirements)
	return "anything"

/decl/merchant_commodity_requirement/type/anything/compare_instance(list/parameters, atom/movable/instance)
	return istype(instance) // This shouldn't ever be false, but...

/decl/merchant_commodity_requirement/type/anything/compare_type(list/parameters, type_path)
	return ispath(type_path, /atom/movable)


/// Basic type check which allows matching types or subtypes to pass.
/// Parameter is the type to be checked against.
/decl/merchant_commodity_requirement/type/type_or_subtype


/decl/merchant_commodity_requirement/type/type_or_subtype/build_parameters(list/parameters)
	return typecacheof(parameters)


/// Basic type check which requires the type to be the exact same.
/// Parameter is the type to be checked against.
/decl/merchant_commodity_requirement/type/exact_type
	verbose_naming = TRUE

/decl/merchant_commodity_requirement/type/exact_type/build_parameters(list/parameters)
	return typecacheof(parameters, only_root_path = TRUE)


/decl/merchant_commodity_requirement/mobs

/// Require that a mob being sold be of a particular species.
/// Parameters are a list of species decls that are wanted.
/decl/merchant_commodity_requirement/mobs/species
	naming_position = 0

/decl/merchant_commodity_requirement/mobs/species/generate_name(list/parameters, list/all_requirements)
	var/list/species_names = list()
	for(var/type_path in parameters)
		var/decl/species/species = GET_DECL(type_path)
		species_names += species.name_plural

	return english_list(species_names, and_text = " or ")

/decl/merchant_commodity_requirement/mobs/species/compare_instance(list/parameters, atom/movable/instance)
	if(!isliving(instance))
		return FALSE
	var/mob/living/L = instance
	var/decl/species/species = L.get_species()
	if(!species)
		return FALSE
	return is_path_in_list(species.type, parameters)


/// Require that a mob be either alive or dead. Unconsciousness counts as living.
/// Parameter is a single value that is TRUE or FALSE. TRUE requires that mobs are alive, while FALSE requires that mobs are dead.
/decl/merchant_commodity_requirement/mobs/is_alive
	naming_position = -1 // Prefix.
	var/alive_text = "living"
	var/dead_text = "dead"

/decl/merchant_commodity_requirement/mobs/is_alive/generate_name(parameter, list/all_requirements)
	return parameter == TRUE ? alive_text : dead_text

/decl/merchant_commodity_requirement/mobs/is_alive/compare_instance(parameter, atom/movable/instance)
	if(!ismob(instance))
		return FALSE
	var/mob/M = instance
	return (M.stat != DEAD) == parameter


/// Functions identically to the regular requirement but with robotic flavor.
/decl/merchant_commodity_requirement/mobs/is_alive/synth
	alive_text = "functional"
	dead_text = "broken"


/// Require that an object be made out of a specific material.
/// Parameter is a single material decl type path.
/decl/merchant_commodity_requirement/material
	naming_position = -1 // Prefix.

/decl/merchant_commodity_requirement/material/compare_instance(parameter, atom/movable/instance)
	return instance.get_material_type() == parameter

/decl/merchant_commodity_requirement/material/compare_type(parameter, type_path)
	if(!ispath(type_path, /obj/item))
		return ..()

	var/obj/item/casted_path = type_path

	// This _might_ produce erroneous results and it might be better to treat this as unanswerable, like most other non-typecheck requirements.
	return initial(casted_path.material) == parameter


/decl/merchant_commodity_requirement/gas
	abstract_type = /decl/merchant_commodity_requirement/gas
	/// Because an object's `return_air()` can return either the object's "gas contents", or its loc's gas,
	/// and there isn't a great way to tell which one it's gonna be, only certain types are allowed here.
	var/static/list/allowed_gas_containers = list(/obj/item/tank, /obj/machinery/portable_atmospherics)


/// Requires that an object which can hold gases be empty.
/// Primarily exists to have the requirement read better. "empty canister" vs "canister containing nothing".
/// Also stops people from scamming merchants who are asking for stuff like portable scrubbers, where players could fill them with expensive gas and sell them for extra.
/// Parameter-less.
/decl/merchant_commodity_requirement/gas/empty
	naming_position = -1 // Prefix.


/decl/merchant_commodity_requirement/gas/empty/generate_name(list/parameters, list/all_requirements)
	return "empty"

/decl/merchant_commodity_requirement/gas/empty/compare_instance(list/parameters, atom/movable/instance)
	if(!is_type_in_list(instance, allowed_gas_containers))
		return FALSE

	var/datum/gas_mixture/gas_mix = instance.return_air()

	if(length(gas_mix.gas))
		return FALSE // Container isn't empty.
	return TRUE


/// Require that an object which can hold gas have a certain ratio of gases contained.
/// Parameters are an assoc list of gas material decls as well as the desired ratio.
/// If only one gas is listed, the object must have only that gas inside, or in other words, it must be pure.
/// If multiple gases are listed, it is allowed to deviate very slightly from the required ratio. Unlisted gases are not allowed.
/decl/merchant_commodity_requirement/gas/ratio
	naming_position = -2 // Prefix.
	var/const/MAX_ALLOWED_RATIO_DEVIATION = 0.01 //! Ratios are allowed to deviate by this much. A value of 0.01 means that the ratio can vary by 1%. If they want 21% oxygen, they will also accept 20% or 22%.

/decl/merchant_commodity_requirement/gas/ratio/build_parameters(list/parameters)
	// Normalize the ratios.
	var/list/normalized_parameters = list()

	var/sum = 0
	for(var/i = 1 to length(parameters))
		sum += parameters[parameters[i]]

	for(var/type_path, ratio in parameters)
		normalized_parameters[type_path] = ratio / sum

	return normalized_parameters

/decl/merchant_commodity_requirement/gas/ratio/generate_name(list/parameters, list/all_requirements)
	var/list/text = list()
	for(var/type_path, ratio in parameters)
		var/decl/material/material = GET_DECL(type_path)
		text += "[length(parameters) == 1 ? "" : "[ratio * 100]% "][material.gas_name]"
	return "[english_list(text)] inside of"

/decl/merchant_commodity_requirement/gas/ratio/compare_instance(list/parameters, atom/movable/instance)
	if(!is_type_in_list(instance, allowed_gas_containers))
		return FALSE

	var/datum/gas_mixture/gas_mix = instance.return_air()

	if(!length(gas_mix.gas))
		return FALSE // Container is empty.

	for(var/gas_type_path in gas_mix.gas)
		if(!parameters[gas_type_path])
			return FALSE // Unwanted gas was found.
		var/actual_ratio = gas_mix.get_gas(gas_type_path) / gas_mix.get_total_moles()
		var/desired_ratio = parameters[gas_type_path]
		if(actual_ratio > desired_ratio + MAX_ALLOWED_RATIO_DEVIATION || actual_ratio < desired_ratio - MAX_ALLOWED_RATIO_DEVIATION)
			return FALSE // Incorrect ratio.
	return TRUE


/// Require that an object which can hold gas have it be close to a specific temperature.
/// Parameter is a numeric value representing the desired temperature of the gas, in kelvin.
/decl/merchant_commodity_requirement/gas/temperature
	naming_position = 2 // Suffix.
	var/const/MAX_ALLOWED_TEMPERATURE_DEVIATION = 2 //! Temperature is allowed to be off by this much (in celsius/kelvin) and still be accepted.

/decl/merchant_commodity_requirement/gas/temperature/generate_name(parameter, list/all_requirements)
	return "at a temperature of [parameter - T0C]&deg;C"

/decl/merchant_commodity_requirement/gas/temperature/compare_instance(parameter, atom/movable/instance)
	if(!is_type_in_list(instance, allowed_gas_containers))
		return FALSE

	var/datum/gas_mixture/gas_mix = instance.return_air()
	if(gas_mix.temperature > parameter + MAX_ALLOWED_TEMPERATURE_DEVIATION || gas_mix.temperature < parameter - MAX_ALLOWED_TEMPERATURE_DEVIATION)
		return FALSE
	return TRUE


/decl/merchant_commodity_requirement/reagents
	abstract_type = /decl/merchant_commodity_requirement/reagents

/// Require that an object which can hold reagents have specific reagents at at certain ratio.
/// Parameters are an assoc list of reagent decls along with the wanted ratios.
/decl/merchant_commodity_requirement/reagents/ratio
	naming_position = -2 // Prefix.
	var/const/MAX_ALLOWED_RATIO_DEVIATION = 0.01

/decl/merchant_commodity_requirement/reagents/ratio/generate_name(list/parameters, list/all_requirements)
	var/list/text = list()
	for(var/type_path, ratio in parameters)
		var/decl/material/material = GET_DECL(type_path)
		text += "[length(parameters) == 1 ? "only" : ratio * 100]% [material.liquid_name]"
	return "[english_list(text)] inside of"

/decl/merchant_commodity_requirement/reagents/ratio/compare_instance(list/parameters, atom/movable/instance)
	var/datum/reagents/reagents = instance.get_reagents()
	if(!reagents)
		return FALSE

	if(!length(REAGENT_VOLUMES(reagents)))
		return FALSE // Container is empty.

	for(var/thing, volume in REAGENT_VOLUMES(reagents))
		var/decl/material/reagent = thing
		if(!parameters[reagent.type])
			return FALSE // Unwanted reagent.
		var/actual_ratio = volume / REAGENT_TOTAL_VOLUME(reagents)
		var/desired_ratio = parameters[reagent.type]
		if(actual_ratio > desired_ratio + MAX_ALLOWED_RATIO_DEVIATION || actual_ratio < desired_ratio - MAX_ALLOWED_RATIO_DEVIATION)
			return FALSE // Incorrect ratio.

	return TRUE


/// Require that an object which can hold reagents have one or more of the reagents wanted.
/// Parameters are a list of desired reagent decls.
/decl/merchant_commodity_requirement/reagents/has_reagents // TODO: Cut this and consolidate into /ratio ?
	naming_position = -1

/decl/merchant_commodity_requirement/reagents/has_reagents/generate_name(list/parameters, list/all_requirements)
	var/list/reagent_names = list()
	if(!islist(parameters))
		parameters = list(parameters)
	for(var/type_path in parameters)
		var/decl/material/material = GET_DECL(type_path)
		reagent_names += material.liquid_name
	return "[english_list(reagent_names, and_text = " or ")] inside of"

/decl/merchant_commodity_requirement/reagents/has_reagents/compare_instance(list/parameters, atom/movable/instance)
	var/datum/reagents/reagents = instance.get_reagents()
	if(!reagents)
		return FALSE

	if(!length(REAGENT_VOLUMES(reagents)))
		return FALSE // Container is empty.

	if(!islist(parameters))
		parameters = list(parameters)

	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(reagents))
		if(!(reagent.type in parameters))
			return FALSE // Unwanted reagent.
	return TRUE



/// Requires that an object which can hold reagents be empty.
/// Primarily exists to stop people from scamming merchants by selling them beakers filled with expensive chemicals that they never asked for.
/// Parameter-less.
/decl/merchant_commodity_requirement/reagents/empty
	naming_position = -1 // Prefix.

/decl/merchant_commodity_requirement/reagents/empty/generate_name(list/parameters, list/all_requirements)
	return "empty"

/decl/merchant_commodity_requirement/reagents/empty/compare_instance(list/parameters, atom/movable/instance)
	var/datum/reagents/reagents = instance.get_reagents()
	if(!reagents)
		return FALSE
	return REAGENT_TOTAL_VOLUME(reagents) == 0

