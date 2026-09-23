/// This holds information about a particular thing a merchant wants to buy or sell.
/// Generally these will be created in bulk by one or more `/decl/merchant_potential_commodities`s held by a merchant instance's `potential_[supply|demand]` lists,
/// and then placed inside that merchant's `active_[supply|demand]` lists.
/datum/merchant_commodity
	var/name = null	//! Shown to players when they ask what the merchant wants. Filled in automatically based on what's contained inside.
	var/spawn_path = null //! The type to instantiate when a merchant sells the commodity to a player.
	var/list/requirements = null //! A list of requirements which must all pass for merchants to agree to buy or sell a particular item from players.
	var/quantity = INFINITY //! Limits how many things a merchant can sell this commodity, or how many they want to buy.
	var/quantity_method = /decl/merchant_quantity_method/instances //! Determines how merchants should count things players are trying to sell to them. More esoteric commodities like reagents or gases need their own method.
	var/price_variance = 1.0 //! A modifier that merchants use to slightly tweak prices on a per-item basis, to introduce a bit of randomness.

/**
Instantiates a new commodity datum, which can have various criteria that will determine if any given item instance will count towards the instance itself.
These conditions can be simple type checks or complex requirements, such as requiring that items be made of a specific material, or have a certain gas or reagent composition.
- `_requirements`: An assoc list containing `/decl/merchant_commodity_requirement`s and their parameters. See each `/decl/merchant_commodity_requirement` for what parameters they expect.
- `_item_quantity_method`: A `/decl/merchant_quantity_method` type path which determines how to count qualifying items being sold. The default method counts item instances (and stack sizes).
Different methods can be used if the merchant is intended to purchase reagents or gas instead, as otherwise they would count the containers instead of the contents of the containers.
Has no purpose if demand is infinite, which it is by default.
- `_item_manual_name`: This exists to allow for more flavorful merchants that might want to use more colloquial terms, or as a last resort if the automatic system just isn't cutting it.
*/
/datum/merchant_commodity/New(list/_requirements, _item_quantity, _item_quantity_method, _item_spawn_path, _item_manual_name)
	requirements = list()

	if(_item_spawn_path)
		spawn_path = _item_spawn_path

	// Build parameters, if needed.
	for(var/type_path, parameters in _requirements)
		var/decl/merchant_commodity_requirement/requirement = GET_DECL(type_path)
		var/list/built_parameters = requirement.build_parameters(parameters)
		requirements[type_path] = built_parameters

	// Set the name.
	if(_item_manual_name)
		name = _item_manual_name
	else
		var/list/name_parts = list()

		if(spawn_path)
			name_parts[atom_info_repository.get_name_for(spawn_path)] = 0

		for(var/type_path, parameters in requirements)
			var/decl/merchant_commodity_requirement/requirement = GET_DECL(type_path)
			var/name_part = requirement.generate_name(parameters, requirements.Copy())
			if(isnull(name_part))
				continue
			name_parts[name_part] = requirement.naming_position

		if(length(name_parts) > 1)
			name_parts = sortTim(name_parts, /proc/cmp_numeric_asc, associative = TRUE)
			name = jointext(name_parts, " ")
		else if(length(name_parts))
			name = name_parts[1]
		else
			CRASH("Merchant commodity datum was not given a name. Requirements: [english_list(requirements)]")

	if(_item_quantity_method)
		quantity_method = _item_quantity_method

	if(!isnull(_item_quantity))
		quantity = _item_quantity


/**
Determines if a given input should pass this commodity instance. All requirements must return TRUE for this to return TRUE.
- `atom/movable/thing`: An object instance, or a type path, that someone is trying to buy or sell to a merchant.
*/
/datum/merchant_commodity/proc/check_requirements(atom/movable/thing)
	for(var/type_path, parameters in requirements)
		var/decl/merchant_commodity_requirement/requirement = GET_DECL(type_path)
		if(ispath(thing) && !requirement.compare_type(parameters, thing))
			return FALSE
		if(!requirement.compare_instance(parameters, thing))
			return FALSE
	return TRUE

/datum/merchant_commodity/proc/get_quantity_of_instance(atom/movable/instance)
	var/decl/merchant_quantity_method/method = GET_DECL(quantity_method)
	return method.get_quantity_of_instance(instance)

/datum/merchant_commodity/proc/print_quantity()
	var/decl/merchant_quantity_method/method = GET_DECL(quantity_method)
	return "[quantity][method.unit_suffix ? " [method.unit_suffix]" : ""]"

/datum/merchant_commodity/proc/print_offer()
	. = name
	if(quantity != INFINITY)
		. = "[print_quantity()] [name]"

