/// Determines what things a merchant might buy or sell, by creating `/datum/merchant_commodity` instances in bulk.
/// Place inside of a merchant's `potential_[supply|demand]` list for them to offer to buy or sell things listed in the decl.
/// These can be reused between different distinct merchants.
/decl/merchant_potential_commodities
	abstract_type = /decl/merchant_potential_commodities

	/// An assoc list which is used to determine what types a merchant will offer to buy or sell.
	/// The format is the type path as the key, and a `MERCHANT_*` bitflag as the value.
	/// Multiple types, similar or otherwise, can be in the same decl, forming a set that is only affected by the data inside the decl.
	/// Example: `list(/obj/item/foo = MERCHANT_INCLUDE_ALL, /obj/item/foo/bar = MERCHANT_EXCLUDE_THIS_TYPE)` will generate commodity instances for
	/// `/obj/item/foo` and all of its subtypes, except for `/obj/item/foo/bar`.
	/// The list is evaluated sequentially, so order matters. Put excludes below the includes.
	/// Seperating into different decls is generally only needed if you plan to have different items have different quantities, probabilities, or requirements,
	/// if you want to buy both regular items and things like reagents/gases, or you want to reuse item lists across different merchants.
	var/list/type_instructions = null

	/// An assoc list of extra requirements which will be applied to all items that this decl will make.
	/// Keys are `/decl/merchant_commodity_requirement` types, and values are the parameters for those requirements.
	var/list/extra_requirements = null

	/// Sets a hard cap on how many datums can be retrieved from this decl.
	var/max_distinct_types = INFINITY

	/// The possible lower bound for an item being bought or sold. This is applied on a per-item basis. Does nothing if `item_quantity_upper_bound` is set to `INFINITY`.
	/// The default value is 0, which means that it's possible for merchants to start with items already sold out or have a particular demand already satisfied,
	/// if `item_quantity_upper_bound` is set to a finite value.
	var/item_quantity_lower_bound = 0

	/// The possible upper bound for an item being bought or sold. This is applied on a per-item basis. Default value is `INFINITY`, which makes merchants buy or sell an unlimited number of items.
	var/item_quantity_upper_bound = INFINITY

	/// Determines the odds that everything defined in this decl can be bought or sold. This can be used to make 'rare item' lists that only show up sometimes on a particular merchant.
	var/decl_probability = 100

	/// Determines the odds that an individual type path can be offered, on a per-item basis.
	var/item_probability = 100

/decl/merchant_potential_commodities/Initialize()
	. = ..()
	post_init()

/// Exists for cross-modpack interactions, mainly for adding type exclusions.
/decl/merchant_potential_commodities/proc/post_init()
	SHOULD_CALL_PARENT(TRUE)


/decl/merchant_potential_commodities/proc/filter_type_paths(list/type_paths)
	var/list/types_included = list()
	for(var/type_path, instruction in type_paths)
		if(instruction & MERCHANT_INCLUDE_THIS_TYPE)
			types_included += type_path
		if(instruction & MERCHANT_INCLUDE_SUBTYPES)
			types_included += subtypesof(type_path)
		if(instruction & MERCHANT_EXCLUDE_THIS_TYPE)
			types_included -= type_path
		if(instruction & MERCHANT_EXCLUDE_SUBTYPES)
			types_included -= subtypesof(type_path)
	return types_included


/decl/merchant_potential_commodities/proc/assign_quantity()
	. = INFINITY
	if(item_quantity_upper_bound != INFINITY)
		. = rand(item_quantity_lower_bound, item_quantity_upper_bound)


/decl/merchant_potential_commodities/proc/create_datums(transaction_direction)
	RETURN_TYPE(/list)

	. = list()
	if(!LAZYLEN(type_instructions))
		return

	var/list/types_included = filter_type_paths(type_instructions)

	for(var/type_path in types_included)
		var/atom/A = type_path
		// Filter out anything weird that might've sneaked in.
		if(!TYPE_IS_SPAWNABLE(A))
			types_included -= type_path

	for(var/type_path in types_included)
		var/list/requirements = list()
		if(transaction_direction == /datum/merchant::TRANSACTION_BUYING)
			requirements[/decl/merchant_commodity_requirement/type/exact_type] = type_path

		for(var/req_type, req_parameters in extra_requirements)
			requirements[req_type] = req_parameters

		. += new /datum/merchant_commodity(
			requirements,
			_item_quantity = assign_quantity(),
			_item_spawn_path = transaction_direction == /datum/merchant::TRANSACTION_SELLING ? type_path : null
		)


/decl/merchant_potential_commodities/proc/get_commodities(transaction_direction, datum/merchant/merchant)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!prob(decl_probability))
		return list() // You get nothing, good day sir.

	var/list/potential = create_datums(transaction_direction)

	// Remove things randomly, if desired.
	if(item_probability < 100)
		for(var/thing in potential)
			if(!prob(item_probability))
				potential -= thing

	// Trim things down if necessary.
	if(length(potential) > max_distinct_types)
		while(length(potential) > max_distinct_types)
			pick_n_take(potential)

	// Vary the prices, if desired.
	for(var/datum/merchant_commodity/commodity as anything in potential)
		commodity.price_variance = rand(1 / merchant.price_variance * 100, 1 * merchant.price_variance * 100) / 100

	return potential


/// Variant which easily creates reagent commodities.
/// Only works with demand.
/decl/merchant_potential_commodities/reagents
	abstract_type = /decl/merchant_potential_commodities/reagents
	var/list/container_types = list(/obj/item/chems)

/decl/merchant_potential_commodities/reagents/create_datums(transaction_direction)
	ASSERT(transaction_direction == /datum/merchant::TRANSACTION_BUYING)
	. = list()

	var/list/reagent_types = filter_type_paths(type_instructions)

	for(var/container_type in container_types)
		for(var/reagent_type in reagent_types)
			var/list/requirements = list()
			requirements[/decl/merchant_commodity_requirement/type/type_or_subtype] = container_type
			requirements[/decl/merchant_commodity_requirement/reagents/has_reagents] = reagent_type

			. += new /datum/merchant_commodity(requirements, _item_quantity = assign_quantity(), _item_quantity_method = /decl/merchant_quantity_method/reagent_units)


/// Easily creates a lot of demands with distinct material demands, such as material stacks, which would otherwise run into issues with map-spawn instances conflicting with instances created 'natually' in-round.
/// Only works with demand.
/decl/merchant_potential_commodities/materials
	abstract_type = /decl/merchant_potential_commodities/materials
	var/list/instance_types = list(/obj/item/stack/material)

/decl/merchant_potential_commodities/materials/create_datums(transaction_direction)
	ASSERT(transaction_direction == /datum/merchant::TRANSACTION_BUYING)
	. = list()

	var/material_types = filter_type_paths(type_instructions)

	for(var/type_path in instance_types)
		for(var/material_type in material_types)
			var/list/requirements = list()
			requirements[/decl/merchant_commodity_requirement/type/type_or_subtype] = type_path
			requirements[/decl/merchant_commodity_requirement/material] = material_type

			. += new /datum/merchant_commodity(requirements, _item_quantity = assign_quantity())


/decl/merchant_potential_commodities/materials/all_mineable_ores
	var/list/allowed_strata_types = list(
		/decl/strata/igneous,
		/decl/strata/sedimentary,
		/decl/strata/metamorphic
	)
	instance_types = list(/obj/item/stack/material/ore)

/decl/merchant_potential_commodities/materials/all_mineable_ores/Initialize()
	. = ..()
	type_instructions = list()

	for(var/type_path in allowed_strata_types)
		var/decl/strata/strata = GET_DECL(type_path)
		var/list/strata_ores = strata.ores_rich.Copy() + strata.ores_sparse.Copy()
		for(var/decl_type in strata_ores)
			type_instructions[decl_type] = MERCHANT_INCLUDE_THIS_TYPE


/// Variant which creates gas commodities.
/// Only works with demand.
/decl/merchant_potential_commodities/gases
	abstract_type = /decl/merchant_potential_commodities/gases
	var/list/list/gas_mixes = list() //! Nested list containing gas mixes and their ratios to add as commodities. Each mix is contained inside of an inner assoc list, with the material path as the key, and the ratio as the value.
	var/list/container_types = list(/obj/machinery/portable_atmospherics/canister) //! What the gas should be inside of. Due to `return_air()` reasons, only `/obj/item/tank` and `/obj/machinery/portable_atmospherics` is allowed.
	var/target_temperature = T20C //! How hot each gas should be in order to be accepted. If blank, no temperature requirement will be added.

/decl/merchant_potential_commodities/gases/create_datums(transaction_direction)
	ASSERT(transaction_direction == /datum/merchant::TRANSACTION_BUYING)
	. = list()

	var/list/gas_types = filter_type_paths(type_instructions)

	var/list/ratios = gas_mixes.Copy()

	for(var/gas_type in gas_types)
		ratios += list(list((gas_type) = 1))

	if(!length(container_types))
		container_types += null

	for(var/list/gas_ratio in ratios)
		for(var/container_type in container_types)
			var/list/requirements = list()
			if(!isnull(container_type))
				requirements[/decl/merchant_commodity_requirement/type/type_or_subtype] = container_type

			if(target_temperature)
				requirements[/decl/merchant_commodity_requirement/gas/temperature] = target_temperature

			requirements[/decl/merchant_commodity_requirement/gas/ratio] = gas_ratio

			. += new /datum/merchant_commodity(requirements, _item_quantity = assign_quantity(), _item_quantity_method = /decl/merchant_quantity_method/moles)
